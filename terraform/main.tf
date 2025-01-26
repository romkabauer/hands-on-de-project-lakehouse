provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}
provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kube_config)
  }
}

module "gcp-storage" {
  source = "./modules/gcp_storage"

  gcp-project-id = var.gcp-project-id
}

module "gcp-registry" {
  source = "./modules/gcp_registry"

  gcp-project-id = var.gcp-project-id
}

module "docker" {
  source = "./modules/docker"

  gcp-project-id = var.gcp-project-id

  registry-location = module.gcp-registry.registry-location
  registry-access-key = module.gcp-registry.registry-access-key

  airflow-repository-id = module.gcp-registry.airflow-repository-id
  data-services-repository-id = module.gcp-registry.data-services-repository-id
}

module "kafka" {
  source = "./modules/kafka"

  brokers-number = 1
}

module "producer" {
  source = "./modules/producer"

  kafka-service-name = module.kafka.kafka-service
  kafka-input-topic = var.kafka-expenses-topic
  registry-secret = module.gcp-registry.registry-secret
  docker-image = "${module.gcp-registry.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${module.gcp-registry.data-services-repository-id}/${module.docker.data-producer-image-name}:${module.docker.data-producer-image-tag}"
}

module "lakehouse" {
  source = "./modules/lakehouse"

  gcp-project-id = var.gcp-project-id
  storage-sa-key = module.gcp-storage.storage-access-key
  expenses-warehouse-bucket-name = module.gcp-storage.expenses-warehouse-bucket-name
}

module "ingestion" {
  source = "./modules/ingestion"
  # May be required to re-apply after init since it requires a destination schema to exist
  depends_on = [ module.lakehouse, module.producer]

  storage-sa-key = module.gcp-storage.storage-access-key
  registry-secret = module.gcp-registry.registry-secret

  kafka-service-name = module.kafka.kafka-service

  kafka_connect_image_name = "${module.gcp-registry.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${module.gcp-registry.data-services-repository-id}/${module.docker.kafka-connect-image-name}"
  kafka_connect_image_tag = module.docker.kafka-connect-image-tag
}

module "airflow" {
  source = "./modules/airflow"

  gcp-project-id = var.gcp-project-id
  registry-secret = module.gcp-registry.registry-secret
  storage-sa-key = module.gcp-storage.storage-access-key
  income-ingestion-bucket-name = module.gcp-storage.income-ingestion-bucket-name

  default-airflow-repository = "${module.gcp-registry.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${module.gcp-registry.airflow-repository-id}/${module.docker.airflow-image-name}"
  airflow-image-tag = module.docker.airflow-image-tag

  producer-image = "${module.gcp-registry.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${module.gcp-registry.data-services-repository-id}/${module.docker.data-producer-image-name}"
  producer-image-tag = module.docker.data-producer-image-tag

  dbt-trino-pkg-image-name = "${module.gcp-registry.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${module.gcp-registry.data-services-repository-id}/${module.docker.dbt-trino-pkg-image-name}"
  dbt-trino-pkg-image-tag = module.docker.dbt-trino-pkg-image-tag
  trino-host = module.lakehouse.trino-host
  trino-port = module.lakehouse.trino-port
  trino-user = module.lakehouse.trino-user

  depends_on = [ module.docker ]
}

# TODO: try to write custom ParDo with pyiceberg to write from kafka to iceberg table
# since built-in Iceberg sink is not woking properly with Beam Python SDK on Flink Runner
# Related issue: https://github.com/apache/beam/issues/31830
# NOTE: can be used as an example of reading from kafka and writing to file

# module "flink" {
#   source = "./modules/flink"

#   kafka-service-name = module.kafka.kafka-service
#   kafka-input-topic = var.kafka-expenses-topic

#   registry-secret = module.gcp-registry.registry-secret
#   beam-python-harness-docker-image = "${module.gcp-registry.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${module.gcp-registry.data-services-repository-id}/${module.docker.beam-python-harness-image-name}:${module.docker.beam-python-harness-image-tag}"
# }
