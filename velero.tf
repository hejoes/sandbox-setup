# #Velero
# resource "aws_s3_bucket" "velero" {
#   bucket = var.velero_bucket

#   tags = {
#     Name = var.velero_bucket
#   }
# }

# resource "aws_s3_bucket_versioning" "velero" {
#   bucket = aws_s3_bucket.velero.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# module "velero" {
#   source  = "terraform-module/velero/kubernetes"
#   version = "1.1.1"

#   namespace_deploy            = true
#   app_deploy                  = true
#   cluster_name                = module.eks.cluster_name
#   bucket                      = var.velero_bucket
#   openid_connect_provider_uri = module.eks.oidc_provider


#   values = [<<EOF
# # https://github.com/vmware-tanzu/helm-charts/tree/master/charts/velero

# image:
#   repository: velero/velero
#   tag: v1.8.1

# # https://aws.amazon.com/blogs/containers/backup-and-restore-your-amazon-eks-cluster-resources-using-velero/
# # https://github.com/vmware-tanzu/velero-plugin-for-aws
# initContainers:
#   - name: velero-plugin-for-aws
#     image: velero/velero-plugin-for-aws:v1.4.1
#     imagePullPolicy: IfNotPresent
#     volumeMounts:
#       - mountPath: /target
#         name: plugins

# # Install CRDs as a templates. Enabled by default.
# installCRDs: true

# # SecurityContext to use for the Velero deployment. Optional.
# # Set fsGroup for `AWS IAM Roles for Service Accounts`
# # see more informations at: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
# securityContext:
#   fsGroup: 1337
#   # fsGroup: 65534

# ##
# ## Parameters for the `default` BackupStorageLocation and VolumeSnapshotLocation,
# ## and additional server settings.
# ##
# configuration:
#   provider: aws

#   backupStorageLocation:
#     name: default
#     provider: aws
#     bucket: "${var.velero_bucket}"
#     prefix: "velero/${var.eks_cluster}"
#     config:
#       region: ${var.region}

#   volumeSnapshotLocation:
#     name: default
#     provider: aws
#     # Additional provider-specific configuration. See link above
#     # for details of required/optional fields for your provider.
#     config:
#       region: ${var.region}

#   # These are server-level settings passed as CLI flags to the `velero server` command. Velero
#   # uses default values if they're not passed in, so they only need to be explicitly specified
#   # here if using a non-default value. The `velero server` default values are shown in the
#   # comments below.
#   # --------------------
#   # `velero server` default: 1m
#   backupSyncPeriod:
#   # `velero server` default: 1h
#   resticTimeout:
#   # `velero server` default: namespaces,persistentvolumes,persistentvolumeclaims,secrets,configmaps,serviceaccounts,limitranges,pods
#   restoreResourcePriorities:
#   # `velero server` default: false
#   restoreOnlyMode:

#   extraEnvVars:
#     AWS_CLUSTER_NAME: ${var.eks_cluster}

#   # Set log-level for Velero pod. Default: info. Other options: debug, warning, error, fatal, panic.
#   logLevel: info

# ##
# ## End of backup/snapshot location settings.
# ##

# ##
# ## Settings for additional Velero resources.
# ##
# rbac:
#   create: true
#   clusterAdministrator: true

# credentials:
#   # Whether a secret should be used as the source of IAM account
#   # credentials. Set to false if, for example, using kube2iam or
#   # kiam to provide IAM credentials for the Velero pod.
#   useSecret: false

# backupsEnabled: true
# snapshotsEnabled: true
# deployRestic: false
# EOF
#   ]

#   # only deploy after all karpenter resources have been created, otherwise no nodes will be provisioned for velero
#   depends_on = [
#     kubectl_manifest.karpenter_node_pool
#   ]
# }
