import os
from datetime import datetime as dt
from google.cloud import storage
from common.logger import get_logger

from writers.abstract_writer import AbstractWriter


class GCSWriter(AbstractWriter):
    def __init__(self, properties: dict):
        self.storage_client = storage.Client() \
            .from_service_account_json(json_credentials_path=properties["creds_path"])
        self.bucket_name = properties.get("bucket_name")
        self.logger = get_logger()

    def write(self, source_path):
        bucket = self.storage_client.bucket(self.bucket_name)
        blob = bucket.blob(os.path.join(
            "incomes_data_source",
            dt.today().strftime('%Y/%m/%d'),
            os.path.split(source_path)[1]))
        blob.upload_from_filename(source_path)
        self.logger.info("File '%s' was uploaded to GCS successfully", source_path)
