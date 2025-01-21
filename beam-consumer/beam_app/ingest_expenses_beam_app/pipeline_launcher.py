import logging
import argparse
import typing
import json
import pyarrow

import apache_beam as beam
from apache_beam.io import (
    kafka,
    WriteToParquet
)

from apache_beam.transforms.window import FixedWindows
from apache_beam.transforms.managed import Write as BeamManagedWrite
from apache_beam.io.fileio import WriteToFiles
from apache_beam.transforms.trigger import (
    AfterProcessingTime,
    AccumulationMode,
    Repeatedly
)

from apache_beam.options.pipeline_options import PipelineOptions
from apache_beam.options.pipeline_options import (
    SetupOptions,
    StandardOptions
)

from apache_beam.transforms.external import JavaJarExpansionService


def get_expansion_service(
    jar="/opt/apache/beam/jars/beam-sdks-java-io-expansion-service.jar", args=None
):
    if args == None:
        args = [
            "--defaultEnvironmentType=PROCESS",
            '--defaultEnvironmentConfig={"command": "/opt/apache/beam/boot"}',
            "--experiments=use_deprecated_read",
        ]
    return JavaJarExpansionService(
        path_to_jar=jar,
        extra_args=["{{PORT}}"] + args,
        classpath=["/opt/apache/beam/jars/beam-sdks-java-io-hadoop-common.jar",
                   "/opt/apache/beam/jars/beam-sdks-java-io-iceberg.jar"]
    )


class ExpenseRow(typing.NamedTuple):
    user_id: str
    user_country: str
    category: str
    amount: float
    currency: str
    custom_message: str


beam.coders.registry.register_coder(ExpenseRow, beam.coders.RowCoder)


class ReadExpensesFromKafka(beam.PTransform):
    def __init__(
        self,
        bootstrap_servers: str,
        topics: typing.List[str],
        group_id: str,
        verbose: bool = False,
        expansion_service: typing.Any = None,
        label: str | None = None,
    ) -> None:
        super().__init__(label)
        self.boostrap_servers = bootstrap_servers
        self.topics = topics
        self.group_id = group_id
        self.verbose = verbose
        self.expansion_service = expansion_service

    def expand(self, input: beam.pvalue.PBegin):
        return (
            input
            | "ReadFromKafka" >> kafka.ReadFromKafka(
                consumer_config={
                    "bootstrap.servers": self.boostrap_servers,
                    "auto.offset.reset": "latest",
                    "group.id": self.group_id,
                },
                topics=self.topics,
                timestamp_policy=kafka.ReadFromKafka.create_time_policy,
                commit_offset_in_finalize=True,
                expansion_service=self.expansion_service
            )
            | "DecodeMessage" >> beam.Map(self.decode_message)
            | "FormatMessage" >> beam.Map(self.format_message).with_output_types(ExpenseRow)
        )

    @staticmethod
    def decode_message(kafka_kv: tuple, verbose: bool = False):
        if verbose:
            print(kafka_kv)
        return kafka_kv[1].decode("utf-8")

    @staticmethod
    def format_message(message: str, verbose: bool = False):
        if verbose:
            print(message)

        payload = json.loads(message)
        return beam.Row(**payload)


def run(argv=None, save_main_session=True):
    parser = argparse.ArgumentParser(description="Beam pipeline arguments")
    parser.add_argument(
        "--kafka_bootstrap_servers",
        dest="kafka_bootstrap",
        default="kafka-headless.kafka:9092",
        help="Kafka bootstrap server addresses",
    )
    parser.add_argument(
        "--kafka_input_topic",
        dest="kafka_input",
        default="expenses",
        help="Kafka input topic name",
    )

    known_args, pipeline_args = parser.parse_known_args(argv)
    pipeline_options = PipelineOptions(pipeline_args)
    pipeline_options.view_as(SetupOptions).save_main_session = save_main_session

    iceberg_config = {
        "table": "test.write_read",
        "catalog_name": "default",
        "catalog_properties": {
            "type": "hadoop",
            # "uri": "http://nessie:19120",
            "warehouse": "file:///test_from_kafka_to_iceberg_write"
        },
        # "triggering_frequency_seconds": 30
    }
    expansion_service = get_expansion_service()

    with beam.Pipeline(options=pipeline_options) as p:
        (
            p | "ReadExpensesFromKafka" >> ReadExpensesFromKafka(
                bootstrap_servers=known_args.kafka_bootstrap,
                topics=[known_args.kafka_input],
                group_id="expenses-reader-group",
                expansion_service=expansion_service
            )
            # p | "Create rows" >> beam.Create([beam.Row(
            #     int_=num,
            #     str_=str(num),
            #     bytes_=bytes(num),
            #     bool_=(num % 2 == 0),
            #     float_=(num + float(num) / 100)) for num in range(100)])
            | beam.WindowInto(
                FixedWindows(1 * 30),
                trigger=Repeatedly(AfterProcessingTime(1 * 30)),
                accumulation_mode=AccumulationMode.DISCARDING
            )
            # | "Write to Iceberg" >> BeamManagedWrite(
            #     "iceberg",
            #     config=iceberg_config,
            #     expansion_service=expansion_service
            # )
            | "CastToString" >> beam.Map(lambda x: str(x))
            | "Write to file" >> WriteToFiles(
                path='test_from_kafka_to_file_write',
                shards=1,
                max_writers_per_bundle=0
            )
            # | "CastToDict" >> beam.Map(lambda x: x.as_dict())
            # | "Write to parquet" >> WriteToParquet(
            #     "test_from_kafka_to_parquet_write",
            #     schema=pyarrow.schema(
            #         [
            #             ("user_id", pyarrow.string()),
            #             ("user_country", pyarrow.string()),
            #             ("category", pyarrow.string()),
            #             ("amount", pyarrow.float64()),
            #             ("currency", pyarrow.string()),
            #             ("custom_message", pyarrow.string()),
            #         ]
            #     ),
            #     record_batch_size=5,
            #     num_shards=1
            # )
        )
