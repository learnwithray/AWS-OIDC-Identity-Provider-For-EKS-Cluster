# Terraform Remote State Datasource
# data "terraform_remote_state" "eks" {
#   backend = "local"
#   config = {
#     path = "../../08-AWS-EKS-Cluster-Basics/01-ekscluster-terraform-manifests/terraform.tfstate"
#    }
# }

### The terraform_remote_state data source uses the latest state snapshot from a specified state backend to retrieve the root module output values from some other Terraform configuration.
data "terraform_remote_state" "eks_terraform_cluster" {
  backend = "remote"
  config = {
    organization = "raysaini19"
    workspaces = {
      name = "eks-terraform"
    }
  }
}


data "aws_eks_cluster" "eks_cluster" {
  name = data.terraform_remote_state.eks_terraform_cluster.outputs.eks_cluster_id
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = data.terraform_remote_state.eks_terraform_cluster.outputs.eks_cluster_id
}


data "aws_partition" "current" {}

data "tls_certificate" "eks_cluster_issuer_url" {
  url = data.terraform_remote_state.eks_terraform_cluster.outputs.cluster_oidc_issuer_url
}


# Terraform Kubernetes Provider
provider "kubernetes" {
  host                   = data.terraform_remote_state.eks_terraform_cluster.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks_terraform_cluster.outputs.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
}

