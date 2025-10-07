variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "rent-me"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)"
  type        = string
  default     = "production"
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
}

# Network Configuration
variable "vpc_id" {
  description = "VPC ID for resources"
  type        = string
}

variable "database_subnet_ids" {
  description = "List of subnet IDs for RDS database (should be private subnets)"
  type        = list(string)
}

variable "apprunner_subnet_ids" {
  description = "List of subnet IDs for App Runner VPC connector (should be private subnets)"
  type        = list(string)
}

# Database Configuration
variable "postgres_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "16.6"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "Initial database storage in GB"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum database storage for autoscaling in GB"
  type        = number
  default     = 100
}

variable "db_backup_retention_period" {
  description = "Number of days to retain database backups"
  type        = number
  default     = 7
}

variable "database_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "rent_me_production"
}

variable "database_username" {
  description = "PostgreSQL master username"
  type        = string
  sensitive   = true
}

variable "database_password" {
  description = "PostgreSQL master password"
  type        = string
  sensitive   = true
}

# App Runner Configuration
variable "apprunner_cpu" {
  description = "CPU units for App Runner (256 = 0.25 vCPU, 512 = 0.5 vCPU, 1024 = 1 vCPU, 2048 = 2 vCPU)"
  type        = string
  default     = "1024"
}

variable "apprunner_memory" {
  description = "Memory for App Runner in MB (512, 1024, 2048, 3072, 4096, 6144, 8192, 10240, 12288)"
  type        = string
  default     = "2048"
}

variable "max_concurrency" {
  description = "Maximum concurrent requests per App Runner instance"
  type        = number
  default     = 100
}

variable "min_instances" {
  description = "Minimum number of App Runner instances"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Maximum number of App Runner instances"
  type        = number
  default     = 10
}

variable "auto_deploy_enabled" {
  description = "Enable automatic deployments when new image is pushed to ECR"
  type        = bool
  default     = false
}

# Rails Configuration
variable "rails_master_key" {
  description = "Rails master key for credentials encryption"
  type        = string
  sensitive   = true
}

# OAuth Configuration
variable "google_oauth_client_id" {
  description = "Google OAuth client ID"
  type        = string
  sensitive   = true
  default     = ""
}

variable "google_oauth_client_secret" {
  description = "Google OAuth client secret"
  type        = string
  sensitive   = true
  default     = ""
}

variable "github_oauth_client_id" {
  description = "GitHub OAuth client ID"
  type        = string
  sensitive   = true
  default     = ""
}

variable "github_oauth_client_secret" {
  description = "GitHub OAuth client secret"
  type        = string
  sensitive   = true
  default     = ""
}
