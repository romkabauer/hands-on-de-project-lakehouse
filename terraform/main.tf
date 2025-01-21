provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}
provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kube_config)
  }
}

# module "gcp-storage" {
#   source = "./modules/gcp_storage"

#   gcp-project-id = var.gcp-project-id
# }

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

# module "airflow" {
#   source = "./modules/airflow"

#   gcp-project-id = var.gcp-project-id

#   registry-secret = module.gcp-registry.registry-secret

#   default-airflow-repository = "${module.gcp-registry.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${module.gcp-registry.airflow-repository-id}/${module.docker.airflow-image-name}"
#   producer-image = "${module.gcp-registry.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${module.gcp-registry.data-services-repository-id}/${module.docker.data-services-image-name}"
#   airflow-image-tag = module.docker.airflow-image-tag
#   data-services-image-tag = module.docker.data-services-image-tag

#   storage-sa-key = module.gcp-storage.storage-access-key
#   storage-bucket-name = module.gcp-storage.storage-bucket-name

#   depends_on = [ module.docker ]
# }

# TODO: try to write custom ParDo with pyiceberg to write from kafka to iceberg table
# since built-in Iceberg sink is not woking properly with Beam Python SDK on Flink Runner
# Related issue: https://github.com/apache/beam/issues/31830

# module "flink" {
#   source = "./modules/flink"

#   kafka-service-name = module.kafka.kafka-service
#   kafka-input-topic = var.kafka-expenses-topic

#   registry-secret = module.gcp-registry.registry-secret
#   beam-python-harness-docker-image = "${module.gcp-registry.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${module.gcp-registry.data-services-repository-id}/${module.docker.beam-python-harness-image-name}:${module.docker.beam-python-harness-image-tag}"
# }
