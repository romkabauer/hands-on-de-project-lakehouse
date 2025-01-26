import os
from datetime import datetime

from airflow import DAG
from airflow.providers.cncf.kubernetes.secret import Secret
from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator

from kubernetes.client import models as k8s


secret_volume = Secret(
    deploy_type="volume",
    deploy_target="/secrets",
    secret=os.environ["GCS_CREDS_SECRET_NAME"],
    key="gcp_creds.json",
)

with DAG(dag_id="etl_expenses",
         tags=["etl", "dbt"],
         start_date=datetime(2025,1,25),
         schedule_interval="*/15 * * * *",
         catchup=False,
         is_paused_upon_creation=False) as dag:
    task = KubernetesPodOperator(
        namespace=os.environ["LAKEHOUSE_NAMESPACE"],
        image=os.environ["ETL_IMAGE"],
        image_pull_secrets=[k8s.V1LocalObjectReference(os.environ["GCP_REGISTRY_SECRET"])],
        cmds=["/tmp/dbt_exec.sh"],
        arguments=["dbt run --profiles-dir profiles"],
        secrets=[secret_volume],
        configmaps=[os.environ["ETL_CONFIG"]],
        name="etl_expenses",
        on_finish_action='delete_succeeded_pod',
        in_cluster=True,
        task_id="task_etl_expenses",
        get_logs=True,
    )

task
