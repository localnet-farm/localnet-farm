function (
    hostname="xxx"
)
[
	{
	    "apiVersion": "v1",
	    "kind": "ConfigMap",
	    "metadata": {
		    "name": "config-domain",
        "namespace": "knative-serving",
        "labels": {
          "app.kubernetes.io/name": "knative-serving",
          "app.kubernetes.io/component": "controller",
          "app.kubernetes.io/version": "1.12.1"
        }
	    },
	    "type": "Opaque",
	    "data": {
        hostname: ""
	    }
	}
] 
