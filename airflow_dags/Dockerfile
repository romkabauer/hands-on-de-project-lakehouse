FROM apache/airflow

RUN pip install apache-airflow-providers-trino==6.0.0

COPY ./dags/ $AIRFLOW_HOME/dags/
