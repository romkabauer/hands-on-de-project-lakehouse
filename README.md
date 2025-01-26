# Data Engineering project of building basic Lakehouse
Goal is to explore various data tools and technologies (cloud and self-hosted) to build basic lakehouse infrastructure enabling data ingestion, storage and modelling.

This monorepo contains:
- `terraform` - infrastructure definition separated by modules (Kafka, GCP, docker, Airflow, Flink, etc.)
- `airflow_dags` - Airflow DAGs with basic examples of scheduled workflows
- `dbt_trino` - dbt project enabling DWH modelling via Trino
- `kafka_connect` - Dockerfile and configurations for Kafka -> Iceberg ingestion
- `transactional_app` - basic Python app to generate (JSON, CSV), serialize (JSON) and write data to supported destinations (Kafka, GCS) in batch and event modes.
- `beam_consumer` - draft of Beam app which could be used for Kafka -> Iceberg ingestion (STILL IN PROGRESS)
### High-level diagram of dataflow
![high_level_diagram_hands_on_de_project](https://github.com/user-attachments/assets/7b29a53a-64f6-4ed0-8649-8ea08951e926)
### High-level diagram of infrastructure
![detail_diagram_hands_on_de_project](https://github.com/user-attachments/assets/26306175-3248-4281-bbdf-f8483fe32157)
### Tools and technologies used
- Infrastructure
  - Terraform
  - Kubernetes
  - Helm
  - Docker
- Data Processing
  - Kafka, Kafka Connect  
  - Trino
  - Apache Flink
  - Apache Beam
- Storage, Catalogs and Metastores
  - Google Cloud Storage
  - Apache Iceberg
  - Nessie Catalog
### Future plans
- Finish Flink+Beam data integration pipeline for streaming data from Kafka to Iceberg table
- Integrate more SQL query engines like Spark, Dremio and make it configurable in TF
- Integrate more catalogs like Hive, Polaris and make it configurable in TF
- Integrate Minio as storage option
