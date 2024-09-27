# resource "helm_release" "argocd" {

#   name       = "argocd"
#   repository = "https://github.com/argoproj/argo-cd.git"
#   chart      = "argo-cd"
#   namespace  = "argocd"
#   version    = "5.51.4" #2.9.2

#   values = [
#     templatefile(
#       "${path.module}/helm-files/argocd.yaml",
#       {
#       }
#     )
#   ]
# }

# resource "helm_release" "aws-load-balancer-controller" {
#   name = "aws-load-balancer-controller-sandbox"
#   repository       = "https://aws.github.io/eks-charts"
#   chart            = "aws-load-balancer-controller"
#   namespace        = "kube-system"
#   version          = "1.4.7"
#   create_namespace = true

#   values = [templatefile("helm-files/aws-load-balancer-controller.yaml", {
#     cluster_name = var.eks_cluster
#     alb_arn      = aws_iam_role.alb-ingress.arn
#     vpcId = module.vpc.vpc_id
#   })]
# }

# resource "helm_release" "external-dns" {
#   name             = "external-dns"
#   chart            = "https://github.com/kubernetes-sigs/external-dns/releases/download/external-dns-helm-chart-1.11.0/external-dns-1.11.0.tgz"
#   namespace        = "external-dns"
#   create_namespace = true
#   values = [templatefile("helm-files/external-dns.yaml", {
#     region  = var.region
#     dns_arn = aws_iam_role.external-dns.arn
#   })]
# }
