# Use this data source to lookup information about the current AWS partition in which Terraform is working.
# reference : https://registry.terraform.io/providers/hashicorp/aws/4.1.0/docs/data-sources/partition
# reference : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider.html
# reference : https://registry.terraform.io/providers/hashicorp/aws/4.1.0/docs/data-sources/partition


# AWS IAM Open ID Connect Provider. A list of server certificate thumbprints for the OpenID Connect identity provider's server certificate
resource "aws_iam_openid_connect_provider" "eks_terrform_cluster_oidc_provider" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [var.eks_oidc_root_ca_thumbprint]
  url             = data.tls_certificate.eks_cluster_issuer_url.url
  tags = {
    name = "${local.eks_cluster_name}-eks-oidc"
  }

}

### remote_access -> ec2_ssh_key: Key Pair name that provides access for remote communication with the worker nodes in the EKS Node Group. 
### If you specify this configuration, but do not specify source_security_group_ids when you create an EKS Node Group, either port 3389 for Windows, 
### or port 22 for all other operating systems is opened on the worker nodes to the Internet (0.0.0.0/0). 
### For Windows nodes, this will allow you to use RDP, for all others this allows you to SSH into the worker nodes.



############################################################################################################
##  Output: AWS IAM Open ID Connect Provider ARN
############################################################################################################
output "eks_cluster_openid_connect_provider_arn" {
  description = "The ARN assigned by AWS IAM Open ID Connect"
  value       = aws_iam_openid_connect_provider.eks_terrform_cluster_oidc_provider.arn
}
# Extract OIDC URL from OIDC Provider ARN (sample - arn:aws:iam::<AWS_ACCOUNT>:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/5700AC86C6B34A7183C27AA3697C5A4B)
locals {
  eks_cluster_openid_connect_provider_arn_extract_from_arn = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.eks_terrform_cluster_oidc_provider.arn}"), 1)
}
# OIDC (Open ID Connect) Provider URL 
output "eks_cluster_openid_connect_provider_arn_extract_from_arn" {
  description = "AWS IAM Open ID Connect Provider extract from ARN"
  value       = local.eks_cluster_openid_connect_provider_arn_extract_from_arn
}