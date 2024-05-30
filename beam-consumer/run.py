import apache_beam as beam
from apache_beam.io import (
    # ReadFromText,
    WriteToText,
    # kafka
)
from apache_beam.options.pipeline_options import PipelineOptions

def run():
    options = PipelineOptions([
        "--runner=FlinkRunner",
        "--flink-master=bq-ingestion.flink:8081",
        "--environment_type=LOOPBACK",
        # "--environment_config=localhost:50000"
    ])

    with beam.Pipeline(options=options) as p:
        output = (
            p | 'Create words' >> beam.Create(['to be or not to be'])
            | 'Split words' >> beam.FlatMap(lambda words: words.split(' '))
            | 'Write to file' >> WriteToText('test', file_name_suffix='.txt')
        )

if __name__ == "__main__":
    run()
