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
      docker build -t ${var.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${var.data-services-repository-id}/${var.data-services-image-name}:${var.data-services-image-tag} ${var.data-services-docker-file-location}
	    docker push ${var.registry-location}-docker.pkg.dev/${var.gcp-project-id}/${var.data-services-repository-id}/${var.data-services-image-name}:${var.data-services-image-tag}
	    EOF
	  }
}
