localnet-farm-3
===

This prototype cluster is provisioned using Terraform to run on AWS, and
runs a single localnet workload, connected via a gateway to a load balancer.

# Issues

* https://github.com/jimpick/localnet-farm/issues/7

# Demo Notebook

* https://observablehq.com/d/f057070d65ef02a6

# Endpoint

* https://gw-3.localnet.farm/

# Images

* https://github.com/jimpick/lotus-fvm-localnet
* https://github.com/jimpick/localnet-farm-gateway

# Terraform Configuration

* https://github.com/jimpick/localnet-farm/tree/main/prototypes/localnet-farm-3/terraform

Deployed using [Terraform Cloud](https://cloud.hashicorp.com/products/terraform)

# Kubernetes Resources / ArgoCD

* https://github.com/jimpick/localnet-farm/tree/main/prototypes/localnet-farm-3/argocd

# Manual install steps

  * Deploy Terraform configuration using Terraform Cloud
  * Deploy Kubernetes resources (see above) using ArgoCD

  * Endpoint:
    * Setup domain in Route53 (localnet.farm)
    * Use AWS Certificate Manager (ACM) to acquire certificate for gw-3.localnet.farm (DNS validation method, create temp records)
    * Map endpoint in Route 53 using an CNAME record to the load balancer address
