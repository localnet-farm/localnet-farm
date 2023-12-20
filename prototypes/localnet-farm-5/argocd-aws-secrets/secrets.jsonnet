function (
    accessKeyId="xxx",
    secretAccessKey="xxx"
)
[
	{
	    "apiVersion": "v1",
	    "kind": "Secret",
	    "metadata": {
		    "name": "prod-route53-credentials-secret",
        "namespace": "cert-manager",
	    },
	    "type": "Opaque",
	    "data": {
        "access-key-id": accessKeyId,
		    "secret-access-key": secretAccessKey
	    }
	}
] 
