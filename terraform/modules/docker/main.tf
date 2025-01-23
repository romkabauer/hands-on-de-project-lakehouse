resource "null_resource" "airflow_dags_pkg" {
      provisioner "local-exec" {
        command = <<EOF
        docker login -u _json_key_base64 -p ${var.registry-access-key} https://${var.registry-location}-docker.pkg.dev
        docker build -t ${var.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${var.airflow-repository-id}/${var.airflow-image-name}:${var.airflow-image-tag} ${var.airflow-docker-file-location}
        docker push ${var.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${var.airflow-repository-id}/${var.airflow-image-name}:${var.airflow-image-tag}
        EOF
      }
}

resource "null_resource" "data_producer_pkg" {
      provisioner "local-exec" {
        command = <<EOF
        docker login -u _json_key_base64 -p ${var.registry-access-key} https://${var.registry-location}-docker.pkg.dev
        docker build -t ${var.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${var.data-services-repository-id}/${var.data-producer-image-name}:${var.data-producer-image-tag} ${var.data-producer-docker-file-location}
        docker push ${var.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${var.data-services-repository-id}/${var.data-producer-image-name}:${var.data-producer-image-tag}
        EOF
      }
}

resource "null_resource" "kafka_connect_pkg" {
      provisioner "local-exec" {
        command = <<EOF
        docker login -u _json_key_base64 -p ${var.registry-access-key} https://${var.registry-location}-docker.pkg.dev
        docker build -t ${var.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${var.data-services-repository-id}/${var.kafka-connect-image-name}:${var.kafka-connect-image-tag} ${var.kafka-connect-docker-file-location}
        docker push ${var.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${var.data-services-repository-id}/${var.kafka-connect-image-name}:${var.kafka-connect-image-tag}
        EOF
      }
}

# resource "null_resource" "beam_python_harness" {
#       provisioner "local-exec" {
#         command = <<EOF
#         docker login -u _json_key_base64 -p ${var.registry-access-key} https://${var.registry-location}-docker.pkg.dev
#         docker build -t ${var.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${var.data-services-repository-id}/${var.beam-python-harness-image-name}:${var.beam-python-harness-image-tag} -f ${var.beam-python-harness-docker-file-location}/${var.beam-python-harness-docker-file-name} ${var.beam-python-harness-docker-file-location}/.
#         docker push ${var.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${var.data-services-repository-id}/${var.beam-python-harness-image-name}:${var.beam-python-harness-image-tag}
#         EOF
#       }
# }
