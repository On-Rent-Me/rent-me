# AWS App Runner Deployment with Terraform

This directory contains Terraform configuration to deploy the Rent Me Rails application to AWS App Runner with a PostgreSQL RDS database.

## Architecture

- **AWS App Runner**: Managed container service running the Rails application
- **Amazon RDS PostgreSQL**: Managed PostgreSQL database
- **Amazon ECR**: Docker image registry
- **AWS Secrets Manager**: Secure storage for credentials and API keys
- **VPC Connector**: Allows App Runner to connect to RDS in private subnets

## Prerequisites

1. **AWS CLI** installed and configured
   ```bash
   aws configure
   ```

2. **Terraform** (>= 1.0) installed
   ```bash
   brew install terraform
   ```

3. **Docker** installed for building images

4. **Existing VPC** with:
   - At least 2 private subnets in different availability zones
   - Internet gateway and NAT gateway configured

## Quick Start

### 1. Configure Variables

Copy the example tfvars file:
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and update:
- `vpc_id`: Your existing VPC ID
- `database_subnet_ids`: Private subnet IDs for RDS
- `apprunner_subnet_ids`: Private subnet IDs for App Runner
- `database_password`: Strong password for PostgreSQL
- `rails_master_key`: Your Rails master key from `config/master.key`
- OAuth credentials (if using Google/GitHub login)

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the Plan

```bash
terraform plan
```

### 4. Apply Configuration

```bash
terraform apply
```

This will create:
- ECR repository
- RDS PostgreSQL database
- App Runner service
- Security groups
- IAM roles and policies
- Secrets Manager secrets

### 5. Build and Push Docker Image

Get ECR login credentials:
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(terraform output -raw ecr_repository_url | cut -d'/' -f1)
```

Build and push the image:
```bash
cd ..
docker build -t rent-me .
docker tag rent-me:latest $(terraform output -raw ecr_repository_url):latest
docker push $(terraform output -raw ecr_repository_url):latest
```

### 6. Run Database Migrations

After the first deployment, you need to run migrations. Connect to the App Runner service and run:

```bash
# Get the service ARN
terraform output apprunner_service_arn

# Use AWS CLI to run migrations (requires AWS CLI v2)
# Note: You may need to use AWS ECS Exec or connect via a bastion host
```

Alternatively, add migration to the Dockerfile or use a one-time container.

### 7. Access Your Application

Get the App Runner URL:
```bash
terraform output apprunner_service_url
```

Your application will be available at: `https://<service-id>.awsapprunner.com`

## Configuration

### Environment Variables

The following environment variables are automatically configured:

**Runtime Variables** (in `main.tf`):
- `RAILS_ENV=production`
- `RAILS_LOG_TO_STDOUT=true`
- `RAILS_SERVE_STATIC_FILES=true`
- `DATABASE_URL`: PostgreSQL connection string
- `POSTGRES_HOST`: RDS endpoint
- `POSTGRES_USER`: Database username
- `POSTGRES_PASSWORD`: Database password

**Secrets** (from AWS Secrets Manager):
- `SECRET_KEY_BASE`: Rails master key
- `GOOGLE_CLIENT_ID`: Google OAuth client ID
- `GOOGLE_CLIENT_SECRET`: Google OAuth client secret
- `GITHUB_CLIENT_ID`: GitHub OAuth client ID
- `GITHUB_CLIENT_SECRET`: GitHub OAuth client secret

### Resource Sizing

Edit `terraform.tfvars` to adjust:

**App Runner**:
- `apprunner_cpu`: CPU units (256, 512, 1024, 2048)
- `apprunner_memory`: Memory in MB (512-12288)
- `min_instances`: Minimum instances (default: 1)
- `max_instances`: Maximum instances (default: 10)
- `max_concurrency`: Requests per instance (default: 100)

**Database**:
- `db_instance_class`: RDS instance type (default: db.t4g.micro)
- `db_allocated_storage`: Initial storage in GB (default: 20)
- `db_max_allocated_storage`: Max storage autoscaling (default: 100)

## Cost Estimate

**App Runner** (us-east-1, 1 vCPU, 2GB RAM):
- Compute: ~$0.064/vCPU-hour + ~$0.007/GB-hour
- With 1 instance running 24/7: ~$51/month

**RDS PostgreSQL** (db.t4g.micro):
- Instance: ~$13.14/month
- Storage (20GB): ~$2.30/month
- Total: ~$15.44/month

**Total Estimated Cost**: ~$66-70/month

## Custom Domain

To use a custom domain:

1. Create a certificate in AWS Certificate Manager
2. Add custom domain to App Runner:
   ```bash
   aws apprunner associate-custom-domain \
     --service-arn $(terraform output -raw apprunner_service_arn) \
     --domain-name yourdomain.com
   ```
3. Update DNS records as instructed

## Monitoring

View logs:
```bash
aws apprunner list-operations --service-arn $(terraform output -raw apprunner_service_arn)
```

CloudWatch Logs are automatically enabled for:
- App Runner application logs
- RDS PostgreSQL logs

## Updating the Application

### Manual Update

1. Build new image with a version tag:
   ```bash
   docker build -t rent-me:v1.0.1 .
   docker tag rent-me:v1.0.1 $(terraform output -raw ecr_repository_url):v1.0.1
   docker push $(terraform output -raw ecr_repository_url):v1.0.1
   ```

2. Update `terraform.tfvars`:
   ```hcl
   image_tag = "v1.0.1"
   ```

3. Apply changes:
   ```bash
   terraform apply
   ```

### Automatic Deployment

Set `auto_deploy_enabled = true` in `terraform.tfvars`. App Runner will automatically deploy when a new image with the specified tag is pushed to ECR.

## Secrets Management

Update secrets without redeploying:

```bash
# Update Rails master key
aws secretsmanager update-secret \
  --secret-id $(terraform output -raw rails_master_key_secret_arn) \
  --secret-string "new_master_key"

# Update OAuth credentials
aws secretsmanager update-secret \
  --secret-id $(terraform output -raw oauth_credentials_secret_arn) \
  --secret-string '{"google_client_id":"xxx","google_client_secret":"yyy"}'
```

## Troubleshooting

### App Runner fails to start

Check logs:
```bash
aws logs tail /aws/apprunner/rent-me-production --follow
```

Common issues:
- Database connection: Verify security groups and VPC connector
- Missing secrets: Check Secrets Manager values
- Image issues: Verify ECR image exists and is accessible

### Database connection timeout

Ensure:
- VPC connector is in the same VPC as RDS
- Security groups allow traffic between App Runner and RDS on port 5432
- Subnets have route to NAT gateway

### Cost optimization

- Use `db.t4g.micro` for development
- Set `min_instances = 0` for development (App Runner will scale to zero)
- Enable auto-scaling to handle traffic spikes
- Use RDS reserved instances for production

## Destroying Resources

To remove all resources:

```bash
terraform destroy
```

**Warning**: This will permanently delete the database and all data unless you have backups enabled.

## Security Best Practices

1. **Never commit** `terraform.tfvars` or `*.tfstate` files
2. **Use AWS Secrets Manager** for all sensitive values
3. **Enable encryption** at rest for RDS (enabled by default)
4. **Restrict security groups** to minimum required access
5. **Enable CloudWatch logs** for monitoring (enabled by default)
6. **Regular backups**: RDS automated backups enabled (7 days retention)
7. **Use private subnets** for database and App Runner VPC connector

## Additional Resources

- [AWS App Runner Documentation](https://docs.aws.amazon.com/apprunner/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Rails on Docker](https://guides.rubyonrails.org/docker.html)
