function (
  volumeHandle="xxx"  
)
[
  {
    "apiVersion": "v1",
    "kind": "Namespace",
    "metadata": {
      "name": "localnet-farm"
    }
  },
  {
    "apiVersion": "v1",
    "kind": "PersistentVolume",
    "metadata": {
      "name": "quick-efs-pv",
      "namespace": "localnet-farm"
    },
    "spec": {
      "capacity": {
        "storage": "5Gi"
      },
      "volumeMode": "Filesystem",
      "accessModes": [
        "ReadWriteOnce"
      ],
      "storageClassName": "efs-sc",
      "persistentVolumeReclaimPolicy": "Retain",
      "csi": {
        "driver": "efs.csi.aws.com",
        "volumeHandle": volumeHandle
      }
    }
  }
]
