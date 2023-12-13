{
  "apiVersion": "v1",
  "kind": "Service",
  "metadata": {
    "name": "envoy",
    "namespace": "contour-external",
    "annotations": {
      "service.beta.kubernetes.io/aws-load-balancer-backend-protocol": "tcp"
    },
    "labels": {
      "networking.knative.dev/ingress-provider": "contour"
    }
  },
  "spec": {
    "externalIPs": [
      "34.209.153.37"
    ],
    "externalTrafficPolicy": "Local",
    "ports": [
      {
        "port": 80,
        "nodePort": 30080,
        "name": "http",
        "protocol": "TCP",
        "targetPort": 8080
      },
      {
        "port": 443,
        "nodePort": 30443,
        "name": "https",
        "protocol": "TCP",
        "targetPort": 8443
      }
    ],
    "selector": {
      "app": "envoy"
    },
    "type": "NodePort"
  }
}
