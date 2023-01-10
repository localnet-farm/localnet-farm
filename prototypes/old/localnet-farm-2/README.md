localnet-farm-2
===

This prototype cluster is provisioned using Terraform to run on AWS, and
runs a single localnet workload, connected via a gateway to a load balancer.

# Issues

* https://github.com/jimpick/localnet-farm/issues/6

# Demo Notebook

* https://observablehq.com/d/faab7184598d4a29

# Endpoint

* https://gw-2.localnet.farm/

# Images

* https://github.com/jimpick/lotus-fvm-localnet
* https://github.com/jimpick/localnet-farm-gateway

# Terraform Configuration

* https://github.com/jimpick/localnet-farm/tree/main/prototypes/localnet-farm-2/terraform

Deployed using [Terraform Cloud](https://cloud.hashicorp.com/products/terraform)

# Kubernetes Resources / ArgoCD

* https://github.com/jimpick/localnet-farm/tree/main/prototypes/localnet-farm-2/argocd

# Manual install steps

  * Deploy Terraform configuration using Terraform Cloud
  * Deploy Kubernetes resources (see above) using ArgoCD

  * Endpoint:
    * Setup domain in Route53 (localnet.farm)
    * Use AWS Certificate Manager (ACM) to acquire certificate for gw-2.localnet.farm (DNS validation method, create temp records)
    * Map endpoint in Route 53 using an A record and an alias to the load balancer
