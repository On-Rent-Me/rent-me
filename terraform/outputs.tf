output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.app.repository_url
}

output "apprunner_service_url" {
  description = "URL of the App Runner service"
  value       = aws_apprunner_service.main.service_url
}

output "apprunner_service_id" {
  description = "ID of the App Runner service"
  value       = aws_apprunner_service.main.service_id
}

output "apprunner_service_arn" {
  description = "ARN of the App Runner service"
  value       = aws_apprunner_service.main.arn
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "database_address" {
  description = "RDS database address"
  value       = aws_db_instance.main.address
  sensitive   = true
}

output "database_port" {
  description = "RDS database port"
  value       = aws_db_instance.main.port
}

output "vpc_connector_arn" {
  description = "ARN of the VPC connector"
  value       = aws_apprunner_vpc_connector.main.arn
}

output "rails_master_key_secret_arn" {
  description = "ARN of the Rails master key secret"
  value       = aws_secretsmanager_secret.rails_master_key.arn
  sensitive   = true
}

output "oauth_credentials_secret_arn" {
  description = "ARN of the OAuth credentials secret"
  value       = aws_secretsmanager_secret.oauth_credentials.arn
  sensitive   = true
}
