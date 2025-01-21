resource "kubernetes_secret" "registry" {
  metadata {
    name = "registry"
    namespace = var.k8s-namespace
  }

  type = "kubernetes.io/dockerconfigjson"

  data = var.registry-secret.data
}

resource "kubernetes_manifest" "beam_app" {
  depends_on = [
    helm_release.flink
  ]
  manifest = yamldecode(<<YAML
apiVersion: flink.apache.org/v1beta1
kind: FlinkDeployment
metadata:
  name: ${var.app-name}
  namespace: ${var.k8s-namespace}
spec:
  image: beam-python-example:1.19
  imagePullPolicy: Never
  flinkVersion: v1_19
  flinkConfiguration:
    taskmanager.numberOfTaskSlots: "2"
  serviceAccount: flink
  podTemplate:
    spec:
      containers:
        - name: flink-main-container
          volumeMounts:
            - mountPath: /opt/flink/log
              name: flink-logs
            - mountPath: /opt/flink/artifacts
              name: flink-artifacts
            - mountPath: /flink-data
              name: flink-data
      volumes:
        - name: flink-logs
          emptyDir:
            sizeLimit: 250Mi
        - name: flink-artifacts
          emptyDir:
            sizeLimit: 250Mi
        - name: flink-data
          emptyDir:
            sizeLimit: 250Mi
  jobManager:
    resource:
      memory: "2048m"
      cpu: 2
  taskManager:
    replicas: 1
    resource:
      memory: "1024m"
      cpu: 2
    podTemplate:
      spec:
        imagePullSecrets:
          - name: ${var.registry-secret.metadata[0].name}
        containers:
          - name: python-harness
            image: ${var.beam-python-harness-docker-image}
            args: ["--worker_pool"]
            ports:
              - containerPort: 50000
                name: harness-port
YAML
    )
}

resource "kubernetes_job" "beam_job" {

  wait_for_completion = false

  depends_on = [ kubernetes_manifest.beam_app ]

  metadata {
    name = "beam-job"
    namespace = var.k8s-namespace
  }
  spec {
    template {
      metadata {
        labels = {
          app = "beam-job"
        }
      }
      spec {
        image_pull_secrets {
          name = var.registry-secret.metadata[0].name
        }
        container {
          name = "beam-job"
          image = var.beam-python-harness-docker-image
          command = ["python3"]
          args = [
            "-m",
            "beam_app.run",
            "--setup_file=/app/beam_app/setup.py",
            "--runner=FlinkRunner",
            "--streaming",
            "--flink_master=${var.app-name}.${var.k8s-namespace}:8081",
            "--environment_type=EXTERNAL",
            "--parallelism=1",
            "--flink_submit_uber_jar",
            "--environment_config=localhost:50000",
            "--checkpointing_interval=10000",
            "--kafka_bootstrap_servers=${var.kafka-service-name}:9092",
            "--kafka_input_topic=${var.kafka-input-topic}"
          ]
        }
        restart_policy = "Never"
      }
    }
  }
}
