# Use this volume if you need to mount particular data to kafka broker
# Tested only with one-node kafka instance

# resource "kubernetes_persistent_volume" "kafka-volume" {
#     metadata {
#       name = "kafka-volume"
#     }

#     spec {
#         capacity = {
#             storage = "1Gi"
#         }
#         access_modes = ["ReadWriteMany"]
#         storage_class_name = "hostpath"
#         persistent_volume_reclaim_policy = "Retain"
#         volume_mode = "Filesystem"
#         persistent_volume_source {
#             host_path {
#                 path = "/var/pv0001/"
#             }
#         }
#     }
# }
