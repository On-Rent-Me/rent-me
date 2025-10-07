terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ECR Repository for Docker images
resource "aws_ecr_repository" "app" {
  name                 = "${var.app_name}-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}"
    Environment = var.environment
  }
}

# ECR Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      selection = {
        tagStatus     = "any"
        countType     = "imageCountMoreThan"
        countNumber   = 10
      }
      action = {
        type = "expire"
      }
    }]
  })
}

# RDS PostgreSQL Database
resource "aws_db_subnet_group" "main" {
  name       = "${var.app_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name        = "${var.app_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_security_group" "database" {
  name        = "${var.app_name}-${var.environment}-db-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.apprunner.id]
    description     = "PostgreSQL from App Runner"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-db-sg"
    Environment = var.environment
  }
}

resource "aws_db_instance" "main" {
  identifier     = "${var.app_name}-${var.environment}-db"
  engine         = "postgres"
  engine_version = var.postgres_version
  instance_class = var.db_instance_class

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_encrypted     = true

  db_name  = var.database_name
  username = var.database_username
  password = var.database_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database.id]

  backup_retention_period = var.db_backup_retention_period
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  skip_final_snapshot       = var.environment != "production"
  final_snapshot_identifier = var.environment == "production" ? "${var.app_name}-${var.environment}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}" : null

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = {
    Name        = "${var.app_name}-${var.environment}-db"
    Environment = var.environment
  }
}

# Security Group for App Runner
resource "aws_security_group" "apprunner" {
  name        = "${var.app_name}-${var.environment}-apprunner-sg"
  description = "Security group for App Runner VPC connector"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-apprunner-sg"
    Environment = var.environment
  }
}

# VPC Connector for App Runner
resource "aws_apprunner_vpc_connector" "main" {
  vpc_connector_name = "${var.app_name}-${var.environment}-vpc-connector"
  subnets            = var.apprunner_subnet_ids
  security_groups    = [aws_security_group.apprunner.id]

  tags = {
    Name        = "${var.app_name}-${var.environment}-vpc-connector"
    Environment = var.environment
  }
}

# IAM Role for App Runner to access ECR
resource "aws_iam_role" "apprunner_access" {
  name = "${var.app_name}-${var.environment}-apprunner-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "build.apprunner.amazonaws.com"
      }
    }]
  })

  tags = {
    Name        = "${var.app_name}-${var.environment}-apprunner-access-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr_access" {
  role       = aws_iam_role.apprunner_access.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

# IAM Role for App Runner Instance
resource "aws_iam_role" "apprunner_instance" {
  name = "${var.app_name}-${var.environment}-apprunner-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "tasks.apprunner.amazonaws.com"
      }
    }]
  })

  tags = {
    Name        = "${var.app_name}-${var.environment}-apprunner-instance-role"
    Environment = var.environment
  }
}

# Secrets Manager for sensitive environment variables
resource "aws_secretsmanager_secret" "rails_master_key" {
  name        = "${var.app_name}-${var.environment}-rails-master-key"
  description = "Rails master key for ${var.app_name}"

  tags = {
    Name        = "${var.app_name}-${var.environment}-rails-master-key"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "rails_master_key" {
  secret_id     = aws_secretsmanager_secret.rails_master_key.id
  secret_string = var.rails_master_key
}

resource "aws_secretsmanager_secret" "oauth_credentials" {
  name        = "${var.app_name}-${var.environment}-oauth-credentials"
  description = "OAuth credentials for ${var.app_name}"

  tags = {
    Name        = "${var.app_name}-${var.environment}-oauth-credentials"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "oauth_credentials" {
  secret_id = aws_secretsmanager_secret.oauth_credentials.id
  secret_string = jsonencode({
    google_client_id     = var.google_oauth_client_id
    google_client_secret = var.google_oauth_client_secret
    github_client_id     = var.github_oauth_client_id
    github_client_secret = var.github_oauth_client_secret
  })
}

# IAM Policy for accessing secrets
resource "aws_iam_policy" "secrets_access" {
  name        = "${var.app_name}-${var.environment}-secrets-access"
  description = "Allow App Runner to access secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]
      Resource = [
        aws_secretsmanager_secret.rails_master_key.arn,
        aws_secretsmanager_secret.oauth_credentials.arn
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_secrets_access" {
  role       = aws_iam_role.apprunner_instance.name
  policy_arn = aws_iam_policy.secrets_access.arn
}

# App Runner Service
resource "aws_apprunner_service" "main" {
  service_name = "${var.app_name}-${var.environment}"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_access.arn
    }

    image_repository {
      image_identifier      = "${aws_ecr_repository.app.repository_url}:${var.image_tag}"
      image_repository_type = "ECR"

      image_configuration {
        port = "8080"

        runtime_environment_variables = {
          RAILS_ENV              = "production"
          RAILS_LOG_TO_STDOUT    = "true"
          RAILS_SERVE_STATIC_FILES = "true"
          DATABASE_URL           = "postgresql://${var.database_username}:${var.database_password}@${aws_db_instance.main.endpoint}/${var.database_name}"
          POSTGRES_HOST          = aws_db_instance.main.address
          POSTGRES_USER          = var.database_username
          POSTGRES_PASSWORD      = var.database_password
        }

        runtime_environment_secrets = {
          SECRET_KEY_BASE      = aws_secretsmanager_secret.rails_master_key.arn
          GOOGLE_CLIENT_ID     = "${aws_secretsmanager_secret.oauth_credentials.arn}:google_client_id::"
          GOOGLE_CLIENT_SECRET = "${aws_secretsmanager_secret.oauth_credentials.arn}:google_client_secret::"
          GITHUB_CLIENT_ID     = "${aws_secretsmanager_secret.oauth_credentials.arn}:github_client_id::"
          GITHUB_CLIENT_SECRET = "${aws_secretsmanager_secret.oauth_credentials.arn}:github_client_secret::"
        }
      }
    }

    auto_deployments_enabled = var.auto_deploy_enabled
  }

  instance_configuration {
    cpu               = var.apprunner_cpu
    memory            = var.apprunner_memory
    instance_role_arn = aws_iam_role.apprunner_instance.arn
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.main.arn
    }
  }

  health_check_configuration {
    protocol            = "HTTP"
    path                = "/up"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 1
    unhealthy_threshold = 5
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}"
    Environment = var.environment
  }

  depends_on = [
    aws_db_instance.main,
    aws_iam_role_policy_attachment.apprunner_ecr_access,
    aws_iam_role_policy_attachment.apprunner_secrets_access
  ]
}

# Auto Scaling Configuration
resource "aws_apprunner_auto_scaling_configuration_version" "main" {
  auto_scaling_configuration_name = "${var.app_name}-${var.environment}-autoscaling"

  max_concurrency = var.max_concurrency
  max_size        = var.max_instances
  min_size        = var.min_instances

  tags = {
    Name        = "${var.app_name}-${var.environment}-autoscaling"
    Environment = var.environment
  }
}

# Custom Domain Configuration
resource "aws_apprunner_custom_domain_association" "main" {
  count = var.custom_domain != "" ? 1 : 0

  domain_name = var.custom_domain
  service_arn = aws_apprunner_service.main.arn
}
