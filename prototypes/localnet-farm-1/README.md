localnet-farm-1
===

This prototype cluster is hand-built on AWS, and runs a single localnet workload, connected via a gateway to a load balancer.

# Issues

* https://github.com/jimpick/localnet-farm/issues/5

# Demo Notebook

* https://observablehq.com/d/a3cb294045f00a51

# Endpoint

* https://gw-1.localnet.farm/

# Images

* https://github.com/jimpick/lotus-fvm-localnet
* https://github.com/jimpick/localnet-farm-gateway

# Manual install

* https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html
  * /Users/jim/fvm-jpimac/localnet-farm/aws-tutorial
  * `eksctl create cluster --name localnet-farm-1 --region us-west-2 --fargate`
  
     ```
     2022-11-22 19:59:02 [ℹ]  eksctl version 0.115.0-dev+2e9feac31.2022-10-14T13:01:18Z
    2022-11-22 19:59:02 [ℹ]  using region us-west-2
    2022-11-22 19:59:02 [ℹ]  setting availability zones to [us-west-2b us-west-2a us-west-2c]
    2022-11-22 19:59:02 [ℹ]  subnets for us-west-2b - public:192.168.0.0/19 private:192.168.96.0/19
    2022-11-22 19:59:02 [ℹ]  subnets for us-west-2a - public:192.168.32.0/19 private:192.168.128.0/19
    2022-11-22 19:59:02 [ℹ]  subnets for us-west-2c - public:192.168.64.0/19 private:192.168.160.0/19
    2022-11-22 19:59:02 [ℹ]  using Kubernetes version 1.23
    2022-11-22 19:59:02 [ℹ]  creating EKS cluster "localnet-farm-1" in "us-west-2" region with Fargate profile
    2022-11-22 19:59:02 [ℹ]  if you encounter any issues, check CloudFormation console or try 'eksctl utils describe-stacks --region=us-west-2 --cluster=localnet-farm-1'
    2022-11-22 19:59:02 [ℹ]  Kubernetes API endpoint access will use default of {publicAccess=true, privateAccess=false} for cluster "localnet-farm-1" in "us-west-2"
    2022-11-22 19:59:02 [ℹ]  CloudWatch logging will not be enabled for cluster "localnet-farm-1" in "us-west-2"
    2022-11-22 19:59:02 [ℹ]  you can enable it with 'eksctl utils update-cluster-logging --enable-types={SPECIFY-YOUR-LOG-TYPES-HERE (e.g. all)} --region=us-west-2 --cluster=localnet-farm-1'
    2022-11-22 19:59:02 [ℹ]  
    2 sequential tasks: { create cluster control plane "localnet-farm-1", 
        2 sequential sub-tasks: { 
            wait for control plane to become ready,
            create fargate profiles,
        } 
    }
    2022-11-22 19:59:02 [ℹ]  building cluster stack "eksctl-localnet-farm-1-cluster"
    2022-11-22 19:59:03 [ℹ]  deploying stack "eksctl-localnet-farm-1-cluster"
    2022-11-22 19:59:33 [ℹ]  waiting for CloudFormation stack "eksctl-localnet-farm-1-cluster"
    ...
    2022-11-22 20:09:05 [ℹ]  waiting for CloudFormation stack "eksctl-localnet-farm-1-cluster"
    2022-11-22 20:11:07 [ℹ]  creating Fargate profile "fp-default" on EKS cluster "localnet-farm-1"
    2022-11-22 20:13:17 [ℹ]  created Fargate profile "fp-default" on EKS cluster "localnet-farm-1"
    2022-11-22 20:13:47 [ℹ]  "coredns" is now schedulable onto Fargate
    2022-11-22 20:14:51 [ℹ]  "coredns" is now scheduled onto Fargate
    2022-11-22 20:14:51 [ℹ]  "coredns" pods are now scheduled onto Fargate
    2022-11-22 20:14:51 [ℹ]  waiting for the control plane to become ready
    2022-11-22 20:14:51 [✔]  saved kubeconfig as "/Users/jim/.kube/config"
    2022-11-22 20:14:51 [ℹ]  no tasks
    2022-11-22 20:14:51 [✔]  all EKS cluster resources for "localnet-farm-1" have been created
    2022-11-22 20:14:52 [ℹ]  kubectl command should work with "/Users/jim/.kube/config", try 'kubectl get nodes'
    2022-11-22 20:14:52 [✔]  EKS cluster "localnet-farm-1" in "us-west-2" region is ready
     ```

  * EKS: https://us-west-2.console.aws.amazon.com/eks/home?region=us-west-2#/clusters
  * CloudFormation: https://us-west-2.console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks?filteringStatus=active&filteringText=&viewNested=true&hideStacks=false
* https://docs.aws.amazon.com/eks/latest/userguide/sample-deployment.html
  * `kubectl create namespace eks-sample-app` 
  * https://docs.aws.amazon.com/eks/latest/userguide/fargate-profile.html
    * `eksctl create fargateprofile --cluster localnet-farm-1 --name sample-app-profile --namespace eks-sample-app`
  * `kubectl create namespace eks-sample-app`
  * `kubectl apply -f eks-sample-deployment.yaml`
  * `kubectl -n eks-sample-app get pods`
  * `kubectl apply -f eks-sample-service.yaml`
  * `kubectl -n eks-sample-app get svc`
* https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
  * `curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-si/aws-load-balancer-controller/v2.4.4/docs/install/iam_policy.json`
  * `aws iam create-policy
    --policy-name AWSLoadBalancerControllerIAMPolicy
    --policy-document file://iam_policy.json`
  * `eksctl utils associate-iam-oidc-provider --region=us-west-2 --cluster=localnet-farm-1`
  * `eksctl utils associate-iam-oidc-provider --region=us-west-2 --cluster=localnet-farm-1 --approve`
  * `eksctl create iamserviceaccount 
  --cluster=localnet-farm-1 
  --namespace=kube-system 
  --name=aws-load-balancer-controller 
  --role-name "AmazonEKSLoadBalancerControllerRole" 
  --attach-policy-arn=arn:aws:iam::727541116171:policy/AWSLoadBalancerControllerIAMPolicy 
  --approve`
  * `helm repo add eks https://aws.github.io/eks-charts`
  * `helm repo update`
  * `helm install aws-load-balancer-controller eks/aws-load-balancer-controller 
  -n kube-system 
  --set clusterName=localnet-farm-1 
  --set serviceAccount.create=false 
  --set serviceAccount.name=aws-load-balancer-controller
  --set region=us-west-2
  --set vpcId=vpc-0ef89b84903e1a951`
  
      ```
      NAME: aws-load-balancer-controller
      LAST DEPLOYED: Tue Nov 22 21:48:48 2022
      NAMESPACE: kube-system
      STATUS: deployed
      REVISION: 1
      TEST SUITE: None
      NOTES:
      AWS Load Balancer controller installed!
      ```

  * `kubectl get deployment -n kube-system aws-load-balancer-controller`
