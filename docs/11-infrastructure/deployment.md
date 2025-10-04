# Infrastructure & Deployment

This document details the infrastructure architecture, deployment processes, and DevOps practices for the RentMe platform.

---

## Hosting Architecture (Azure)

### App Service

**API & SPA Hosting:**
- Azure Web App for API and SPA
- App Service Plan: Standard or Premium tier
- Always On enabled
- Auto-scaling rules based on CPU/memory
- Deployment slots (staging, production)
- Zero-downtime deployments via slot swaps

**Configuration:**
```yaml
service_plan:
  tier: Standard/Premium
  instances:
    min: 2
    max: 10
  auto_scale:
    cpu_threshold: 70%
    memory_threshold: 80%
  features:
    always_on: true
    https_only: true
    managed_certificates: true
```

### Azure Functions

**Serverless Background Processing:**
- Consumption plan for background processing
- Triggered by HTTP, timer, queue
- Event-driven architecture
- Automatic scaling

**Function Types:**
- Image processing tasks
- Report generation
- Webhook processing
- Scheduled batch operations

### Azure SQL Database

**Database Configuration:**
- Standard or Premium tier
- Automated backups (point-in-time restore)
- Geo-replication for disaster recovery
- Connection pooling for performance
- 7-day automated backup retention

**Performance Settings:**
```yaml
database:
  tier: Standard/Premium
  dtu: S3/P2
  max_size: 250GB
  features:
    auto_tuning: enabled
    threat_detection: enabled
    transparent_encryption: enabled
  backup:
    retention: 7_days
    geo_replication: enabled
```

### Azure Blob Storage

**Storage Configuration:**
- General Purpose v2 account
- Hot tier for frequent access (photos)
- Cool tier for archives (old documents)
- Lifecycle policies to archive old data
- Redundancy: Locally-redundant storage (LRS) or Geo-redundant (GRS)

**Storage Containers:**
```yaml
containers:
  property_photos:
    tier: hot
    public_access: blob
    cdn_enabled: true

  maintenance_photos:
    tier: hot
    public_access: blob

  documents:
    tier: cool
    public_access: private
    encryption: enabled

  profile_photos:
    tier: hot
    public_access: blob
```

### Azure CDN

**Content Delivery Configuration:**
- Standard Microsoft CDN
- Caching rules for static assets
- HTTPS enabled with custom domain
- Global edge locations
- Cache purge capabilities

**Caching Rules:**
```yaml
cdn_rules:
  images:
    pattern: "*.{jpg,jpeg,png,gif,svg}"
    cache_duration: 30_days

  static_assets:
    pattern: "*.{css,js}"
    cache_duration: 7_days

  documents:
    pattern: "*.pdf"
    cache_duration: 1_day
```

---

## Database Management

### Schema Management

**Entity Framework Code-First Migrations:**
- Migrations stored in source control
- Applied via deployment pipeline or Hangfire job
- Automatic migration on deployment (staging only)
- Manual migration approval for production

**Migration Process:**
```bash
# Generate migration
Add-Migration MigrationName

# Apply to database
Update-Database

# Script for production
Script-Migration -From LastMigration -To MigrationName
```

### Connection Strings

**Configuration:**
- Stored in Azure App Settings (encrypted)
- Different per environment (dev, test, prod)
- Connection pooling enabled
- Failover partner for high availability

**Connection String Format:**
```
Server=tcp:{server}.database.windows.net,1433;
Database={database};
User ID={user};
Password={password};
Encrypt=True;
TrustServerCertificate=False;
Connection Timeout=30;
MultipleActiveResultSets=True;
```

### Performance Optimization

**Indexing Strategy:**
```sql
-- High-traffic queries
CREATE INDEX IX_Properties_OwnerId ON Properties(OwnerId);
CREATE INDEX IX_Properties_CompanyId ON Properties(CompanyId);
CREATE INDEX IX_Properties_IsPropertyActive ON Properties(IsPropertyActive) WHERE IsDeleted = 0;
CREATE INDEX IX_Properties_City_State ON Properties(City, State) WHERE IsDeleted = 0;

CREATE INDEX IX_LeasePeriods_PropertyId ON LeasePeriods(PropertyId);
CREATE INDEX IX_LeaseTenants_TenantId ON LeaseTenants(TenantId);
CREATE INDEX IX_LeaseTenants_LeasePeriodId ON LeaseTenants(LeasePeriodId);

CREATE INDEX IX_Billings_LeasePeriodId ON Billings(LeasePeriodId);
CREATE INDEX IX_Billings_DueDate ON Billings(DueDate) WHERE IsDeleted = 0;
CREATE INDEX IX_AutoBillings_LeasePeriodId ON AutoBillings(LeasePeriodId);

CREATE INDEX IX_BillingPayments_LeasePeriodId ON BillingPayments(LeasePeriodId);
CREATE INDEX IX_BillingPayments_PaidByUserId ON BillingPayments(PaidByUserId);
CREATE INDEX IX_BillingPayments_TransactionId ON BillingPayments(TransactionId);

CREATE INDEX IX_MaintenanceRequests_LeasePeriodId ON MaintenanceRequests(LeasePeriodId);
CREATE INDEX IX_MaintenanceRequests_TenantId ON MaintenanceRequests(TenantId);
CREATE INDEX IX_MaintenanceRequests_Status ON MaintenanceRequests(Status) WHERE IsDeleted = 0;

CREATE INDEX IX_Leads_PropertyId ON Leads(PropertyId);
CREATE INDEX IX_Leads_UserId ON Leads(UserId);
```

**Query Optimization:**
- Covering indexes on common queries
- Query plan optimization
- Connection pooling
- Read replicas for reporting (future)

### Backup Strategy

**Automated Backups:**
- Daily automated backups (Azure SQL)
- 7-day retention
- Point-in-time restore capability
- Manual backups before major releases
- Geo-redundant backup storage

**Recovery Testing:**
- Monthly restore tests
- Documented recovery procedures
- RTO: 1 hour
- RPO: 15 minutes

---

## CI/CD Pipeline (Azure DevOps / TFS)

### Source Control

**Repository Structure:**
- Team Foundation Version Control (TFVC)
- Branching strategy: Dev → Test → Production
- Pull requests for code review
- Branch policies enforced

**Branching Strategy:**
```
main/
├── Dev/                    # Development branch
├── Dev-Design/             # UI/UX design branch
├── Dev-Payments/           # Payment integration branch
├── Dev-Rent/               # Core rental features branch
├── Dev-ShareAble/          # Credit reporting branch
└── Production/             # Production branch
```

### Build Pipeline

**Build Steps:**
1. Trigger on commit to Dev branch
2. Restore NuGet packages
3. Build .NET solution
4. Run unit tests
5. Build frontend (Grunt)
6. Publish artifacts
7. Run code analysis
8. Generate build report

**Build Configuration:**
```yaml
trigger:
  branches:
    include:
      - Dev
      - Test
      - Production

pool:
  vmImage: 'windows-latest'

steps:
  - task: NuGetCommand@2
    displayName: 'Restore NuGet packages'
    inputs:
      restoreSolution: '**/*.sln'

  - task: VSBuild@1
    displayName: 'Build solution'
    inputs:
      solution: '**/*.sln'
      msbuildArgs: '/p:Configuration=Release'

  - task: VSTest@2
    displayName: 'Run unit tests'
    inputs:
      testAssemblyVer2: |
        **\*test*.dll
        !**\obj\**

  - task: Grunt@0
    displayName: 'Build frontend'
    inputs:
      gruntFile: 'RentMe.Web.SPA/Gruntfile.js'
      targets: 'build:prod'

  - task: PublishBuildArtifacts@1
    displayName: 'Publish artifacts'
```

### Release Pipeline

**Deployment Steps:**

**Staging Deployment:**
1. Deploy API to Azure Web App staging slot
2. Deploy SPA to Web App staging slot
3. Deploy Azure Functions
4. Run database migrations (automatic)
5. Smoke tests
6. Health check verification

**Production Deployment:**
1. Manual approval required
2. Backup production database
3. Deploy to production slot (or slot swap)
4. Run database migrations (manual approval)
5. Smoke tests
6. Monitor for 30 minutes
7. Complete or rollback

**Release Configuration:**
```yaml
stages:
  - stage: Staging
    jobs:
      - deployment: DeployWebApp
        environment: staging
        strategy:
          runOnce:
            deploy:
              steps:
                - task: AzureWebApp@1
                  inputs:
                    azureSubscription: 'Azure-Subscription'
                    appName: 'rentme-staging'
                    package: '$(Pipeline.Workspace)/**/*.zip'
                    deployToSlotOrASE: true
                    slotName: 'staging'

                - task: AzureFunctionApp@1
                  inputs:
                    azureSubscription: 'Azure-Subscription'
                    appName: 'rentme-functions-staging'
                    package: '$(Pipeline.Workspace)/**/functions.zip'

  - stage: Production
    dependsOn: Staging
    condition: succeeded()
    jobs:
      - deployment: DeployWebApp
        environment: production
        strategy:
          runOnce:
            deploy:
              steps:
                - task: AzureAppServiceManage@0
                  displayName: 'Swap slots'
                  inputs:
                    azureSubscription: 'Azure-Subscription'
                    WebAppName: 'rentme-prod'
                    SourceSlot: 'staging'
                    SwapWithProduction: true
```

### Environments

**Development:**
- Auto-deploy on commit to Dev branch
- Latest features and changes
- Used for internal testing
- Database: Dev database

**Test (Staging):**
- Manual promotion from Dev
- QA environment for testing
- Production-like configuration
- Database: Test database (copy of production)

**Production:**
- Manual promotion with approvals
- Live environment serving users
- Blue-green deployment via slot swaps
- Database: Production database

---

## Monitoring & Logging

### Application Insights

**Instrumentation:**
- Automatic instrumentation for requests, dependencies, exceptions
- Custom events for business metrics
- Alerting on error rates, slow requests
- Live metrics stream
- User session tracking

**Monitored Metrics:**
```yaml
metrics:
  requests:
    - response_time_p50
    - response_time_p95
    - response_time_p99
    - request_rate
    - failure_rate

  dependencies:
    - database_query_time
    - external_api_latency
    - cache_hit_rate

  exceptions:
    - exception_rate
    - exception_types
    - stack_traces

  custom_events:
    - user_registrations
    - property_listings
    - applications_submitted
    - payments_completed
```

### Custom Logging

**Logging Framework:**
- `ILogger` abstraction wraps Application Insights
- Structured logging with context
- Log levels: Trace, Debug, Information, Warning, Error, Critical
- Correlation IDs for request tracking

**Log Categories:**
```csharp
// Payment processing
_logger.LogInformation(
    "Payment initiated: {TransactionId} for {Amount} by {UserId}",
    transactionId, amount, userId
);

// Error logging
_logger.LogError(
    exception,
    "Payment failed: {TransactionId} - {Reason}",
    transactionId, reason
);

// Performance logging
using (_logger.BeginScope("Processing rent collection"))
{
    _logger.LogInformation("Starting batch processing");
    // ... processing logic
    _logger.LogInformation("Completed in {Duration}ms", duration);
}
```

### Alerts & Notifications

**Alert Rules:**
```yaml
alerts:
  critical:
    - error_rate > 1%
    - response_time_p95 > 5s
    - database_connection_failures
    - payment_processing_failures > 5
    notification: email, sms, pagerduty

  warning:
    - error_rate > 0.5%
    - response_time_p95 > 3s
    - failed_background_jobs
    notification: email, slack

  info:
    - high_traffic_spike
    - unusual_usage_patterns
    notification: slack
```

**Notification Channels:**
- Email for critical errors
- SMS for after-hours critical alerts
- Slack integration for warnings
- PagerDuty for on-call incidents

### Performance Monitoring

**Key Performance Indicators:**
```yaml
kpis:
  availability:
    target: 99.9%
    measurement: uptime_percentage

  response_time:
    p50: < 200ms
    p95: < 1s
    p99: < 3s

  error_rate:
    target: < 0.1%
    measurement: failed_requests / total_requests

  database:
    query_time_p95: < 100ms
    connection_pool_utilization: < 80%

  background_jobs:
    success_rate: > 99%
    average_execution_time: varies_by_job
```

---

## Security

### HTTPS & Certificates

**Configuration:**
- HTTPS enforced on all endpoints
- Azure-managed SSL certificate
- TLS 1.2+ required
- HSTS headers enabled
- Certificate auto-renewal

**Security Headers:**
```yaml
headers:
  Strict-Transport-Security: "max-age=31536000; includeSubDomains"
  X-Content-Type-Options: "nosniff"
  X-Frame-Options: "SAMEORIGIN"
  X-XSS-Protection: "1; mode=block"
  Content-Security-Policy: "default-src 'self'"
```

### Authentication & Authorization

**OAuth 2.0 Configuration:**
- Bearer token authentication
- Token expiration: 24 hours
- Refresh token flow
- Token validation middleware

**Authorization:**
- Role-based access control (RBAC)
- Resource-based authorization
- Company-level permissions
- API rate limiting per user role

### Data Encryption

**Encryption at Rest:**
- Azure SQL Transparent Data Encryption (TDE)
- Blob storage encryption
- Encrypted backups

**Encryption in Transit:**
- TLS 1.2+ for all connections
- Certificate pinning for mobile apps (future)

**Sensitive Data Handling:**
- SSN encryption with key rotation
- Bank account number encryption
- PCI compliance for payment data (Braintree hosted fields)

### Secrets Management

**Azure Key Vault:**
- API keys and secrets
- Connection strings
- Certificate storage
- Managed identities for Azure services

**Configuration:**
```yaml
secrets:
  storage:
    type: azure_key_vault
    vault_name: rentme-keyvault

  access:
    method: managed_identity
    principals:
      - rentme-webapp
      - rentme-functions

  rotation:
    schedule: 90_days
    automatic: true
```

### Rate Limiting

**Rate Limits:**
```yaml
rate_limits:
  anonymous:
    requests_per_hour: 100
    burst: 20

  authenticated:
    requests_per_hour: 1000
    burst: 50

  admin:
    unlimited: true

  tracking:
    method: distributed_cache
    cache: redis

  response:
    status_code: 429
    headers:
      - X-RateLimit-Limit
      - X-RateLimit-Remaining
      - X-RateLimit-Reset
```

---

## Scaling & Performance

### Horizontal Scaling

**Auto-Scale Configuration:**
```yaml
auto_scale:
  min_instances: 2
  max_instances: 10

  scale_out:
    - metric: cpu
      threshold: 70%
      increase: 2_instances

    - metric: memory
      threshold: 80%
      increase: 2_instances

    - metric: http_queue_length
      threshold: 100
      increase: 1_instance

  scale_in:
    - metric: cpu
      threshold: 30%
      decrease: 1_instance
      cooldown: 10_minutes
```

### Database Scaling

**Vertical Scaling:**
- Increase DTUs as needed
- Elastic pool for multiple databases
- Monitor performance metrics

**Horizontal Scaling (Future):**
- Read replicas for reporting
- Sharding for multi-tenancy
- Database partitioning

### Caching Strategy

**Azure Redis Cache:**
```yaml
cache:
  tier: Standard
  size: C1

  use_cases:
    - session_state
    - api_responses
    - rate_limiting
    - distributed_locks

  ttl:
    session: 24_hours
    api_response: 5_minutes
    static_data: 1_day
```

**In-Memory Caching:**
- Static data (enums, config)
- Frequently accessed reference data
- Application-level cache

### Queue Processing

**Azure Service Bus:**
- Async operations
- Background job processing
- Decoupled workload from web requests
- Dead-letter queue for failed messages

---

## Disaster Recovery

### Backup Strategy

**Database Backups:**
- Automated daily backups
- 7-day retention
- Geo-redundant storage
- Point-in-time restore

**Application Backups:**
- Configuration backups
- Code repository (source control)
- Infrastructure as Code (ARM templates)

### Recovery Procedures

**Recovery Time Objective (RTO):** 1 hour
**Recovery Point Objective (RPO):** 15 minutes

**Recovery Steps:**
1. Identify failure scope
2. Activate incident response
3. Restore from backup or failover
4. Verify data integrity
5. Resume operations
6. Post-mortem analysis

---

## Cost Optimization

### Resource Optimization

**Compute:**
- Right-size instances based on usage
- Auto-scaling to reduce idle capacity
- Reserved instances for predictable workloads
- Spot instances for background jobs (Azure Spot VMs)

**Database:**
- Optimize queries to reduce DTU usage
- Use read replicas for reporting
- Archive old data to cheaper storage
- Database advisor recommendations

**Storage:**
- Lifecycle policies for cold storage
- Compress images and documents
- CDN to reduce origin bandwidth
- Clean up orphaned blobs

**Third-Party Services:**
- Review ProfitStars transaction fees
- Optimize Braintree usage (ACH preferred)
- Negotiate SendGrid plan based on volume
- Monitor API usage and costs

---

## Environment Configuration

### Environment Variables

**Staging:**
```yaml
ASPNETCORE_ENVIRONMENT: Staging
DATABASE_CONNECTION: [staging-connection-string]
AZURE_STORAGE_CONNECTION: [staging-storage]
APPLICATION_INSIGHTS_KEY: [staging-key]
SENDGRID_API_KEY: [staging-key]
BRAINTREE_ENVIRONMENT: sandbox
PROFITSTARS_ENVIRONMENT: test
```

**Production:**
```yaml
ASPNETCORE_ENVIRONMENT: Production
DATABASE_CONNECTION: [prod-connection-string]
AZURE_STORAGE_CONNECTION: [prod-storage]
APPLICATION_INSIGHTS_KEY: [prod-key]
SENDGRID_API_KEY: [prod-key]
BRAINTREE_ENVIRONMENT: production
PROFITSTARS_ENVIRONMENT: production
```

---

## Deployment Checklist

**Pre-Deployment:**
- [ ] Code review completed
- [ ] Unit tests passing
- [ ] Integration tests passing
- [ ] Security scan completed
- [ ] Database migration script reviewed
- [ ] Rollback plan documented
- [ ] Stakeholders notified

**Deployment:**
- [ ] Deploy to staging
- [ ] Run smoke tests
- [ ] Verify integrations
- [ ] Performance test
- [ ] Approve for production
- [ ] Deploy to production
- [ ] Verify deployment
- [ ] Monitor for 30 minutes

**Post-Deployment:**
- [ ] Verify all systems operational
- [ ] Check error rates
- [ ] Review performance metrics
- [ ] User acceptance testing
- [ ] Update documentation
- [ ] Close deployment ticket
