output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "github_deployer_role_arn" {
  value = aws_iam_role.github_deployer.arn
}
