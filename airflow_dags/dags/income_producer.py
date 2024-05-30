import os
from datetime import datetime

from airflow import DAG
from airflow.providers.cncf.kubernetes.secret import Secret
from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator

from kubernetes.client import models as k8s


secret_volume = Secret(
    deploy_type="volume",
    deploy_target="/secrets",
    secret=os.environ["GCP_CREDS_SECRET_NAME"],
    key="gcp_creds.json",
)

with DAG(dag_id="income_producer",
         tags=["ingestion"],
         start_date=datetime(2024,2,10),
         schedule_interval="@daily",
         catchup=False,
         is_paused_upon_creation=False) as dag:
    task = KubernetesPodOperator(
        namespace=os.environ["PRODUCER_BATCH_NAMESPACE"],
        image=os.environ["PRODUCER_BATCH_IMAGE"],
        image_pull_secrets=[k8s.V1LocalObjectReference(os.environ["GCP_REGISTRY_SECRET"])],
        cmds=["python", "./run.py"],
        env_vars={
            "GOOGLE_APPLICATION_CREDENTIALS": "/secrets/gcp_creds.json",
        },
        secrets=[secret_volume],
        configmaps=[os.environ["PRODUCER_BATCH_CONFIG"]],
        name="income_producer",
        on_finish_action="delete_pod",
        in_cluster=True,
        task_id="task_income_producer",
        get_logs=True,
    )

task
