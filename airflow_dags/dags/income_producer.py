import os
from datetime import datetime

from airflow import DAG
from airflow.providers.cncf.kubernetes.secret import Secret
from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator
from airflow.providers.trino.transfers.gcs_to_trino import GCSToTrinoOperator

from kubernetes.client import models as k8s


secret_volume = Secret(
    deploy_type="volume",
    deploy_target="/secrets",
    secret=os.environ["GCS_CREDS_SECRET_NAME"],
    key="gcp_creds.json",
)

with DAG(dag_id="income_producer",
         tags=["ingestion"],
         start_date=datetime(2024,2,10),
         schedule_interval="@daily",
         catchup=False,
         is_paused_upon_creation=False) as dag:
    generate_incomes = KubernetesPodOperator(
        namespace=os.environ["PRODUCER_BATCH_NAMESPACE"],
        image=os.environ["PRODUCER_BATCH_IMAGE"],
        image_pull_secrets=[k8s.V1LocalObjectReference(os.environ["GCP_REGISTRY_SECRET"])],
        cmds=["python", "./run.py"],
        env_vars={
            "GOOGLE_APPLICATION_CREDENTIALS": "/secrets/gcp_creds.json",
        },
        secrets=[secret_volume],
        configmaps=[os.environ["PRODUCER_BATCH_CONFIG"]],
        name="generate_incomes",
        on_finish_action='delete_succeeded_pod',
        in_cluster=True,
        task_id="generate_incomes",
        get_logs=True,
    )

    # NOTE: target table should be created in Trino before running this DAG
    # TODO: Pre-configure/modiy target table in Trino on deploy
    ingest_incomes = GCSToTrinoOperator(
        task_id="ingest_incomes",
        gcp_conn_id="gcs_ingestion_bucket",
        trino_conn_id="trino",
        source_bucket=os.environ["INCOME_INGESTION_BUCKET_NAME"],
        source_object=f"incomes_data_source/{datetime.now().strftime('%Y/%m/%d')}/tmp_data.csv",
        trino_table=os.environ["TRINO_ING_TARGET_TABLE"]
    )

generate_incomes >> ingest_incomes
