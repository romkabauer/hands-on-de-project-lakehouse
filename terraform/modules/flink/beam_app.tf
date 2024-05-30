resource "kubernetes_manifest" "beam-app" {
    manifest = yamldecode(<<YAML
apiVersion: flink.apache.org/v1beta1
kind: FlinkDeployment
metadata:
  name: bq-ingestion
  namespace: flink
spec:
  image: bq-ingestion:0.1.0
  flinkVersion: v1_16
  flinkConfiguration:
    taskmanager.numberOfTaskSlots: "2"
  serviceAccount: flink
  jobManager:
    resource:
      memory: "2048m"
      cpu: 1
  taskManager:
    resource:
      memory: "1024m"
      cpu: 1
  job:
    jarURI: local:///opt/flink/opt/flink-python_2.12-1.16.1.jar.jar
    entryClass: "org.apache.flink.client.python.PythonDriver"
    args: ["-pyclientexec", "/usr/local/bin/python3", "-py", "/opt/flink/app/run.py"]
    parallelism: 2
    upgradeMode: stateless
YAML
    )
}
