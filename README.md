This repo can be used to create sandbox EKS fargate cluster that uses Karpenter to provision nodes based on pods memory/cpu usage. After EKS & Karpenter, it sets up Velero and s3 bucket for backups & DR

SQS and EventBridge are created under karpenter submodule to handle spot interruptions and spin up new node, drain old node and move pods over before the old spot node is removed.

# SETUP

## Prerequisites
<!-- - AWS VPN client & connection. -->
- Exported AWS Access and Secret Key

### Good to have

- AWS CLI tool - https://aws.amazon.com/cli/

<!-- - ArgoCD CLI tool - https://argo-cd.readthedocs.io/en/stable/cli_installation/ -->

## Running the script

1. Go to terraform.tfvars 
1. Change velero_bucket and eks_cluster to desired values. Add more common_tags if needed.
1. `terraform apply --auto-approve`
1. Update kubeconfig `aws eks --region eu-north-1 update-kubeconfig --name $TF_VARS_EKS_CLUSTER`

## Debugging

If somehow on the first run you get karpenter context deadline exceeded, just run apply again.

Ignore vpc.tf for now, it is used for local testing before moving to Test Account

# TEST KARPENTER NODE SCALING

Instructions taken from: https://karpenter.sh/docs/getting-started/getting-started-with-karpenter/#6-scale-up-deployment

`kubectl scale deployment inflate --replicas 5`
`kubectl logs -f -n karpenter -l app.kubernetes.io/name=karpenter -c controller`

# DESTROY

1. **NB! `tf destroy` does not delete nodes and its resources besides Fargate nodes that Karpenter has provisioned**. Therefore it's important to delete all Karpenter provisioned nodes manually `kubectl delete node`.
2. Make sure all nodes have successfully been shut down.
3. Run `terraform destroy`
