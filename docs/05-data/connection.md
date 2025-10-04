# Azure SQL Database Connection Information

## Server Details

- **Server**: rentmedbserver.database.windows.net
- **Admin User**: reduser
- **Admin Password**: Redemption2#
- **Resource Group**: RentMe-ResourceGroup
- **Location**: West US
- **Subscription**: Pay-As-You-Go (cb118074-a11a-4ec4-8fbe-7d5c6bc4d1f4)

## Available Databases

### 1. RentMeDb-Test (Staging/Test Database)
- **Edition**: Basic
- **Status**: Online
- **Purpose**: Testing and staging environment

**Connection String:**
```
Server=tcp:rentmedbserver.database.windows.net,1433;
Initial Catalog=RentMeDb-Test;
User ID=reduser;
Password=Redemption2#;
Encrypt=true;
TrustServerCertificate=False;
Connection Timeout=30;
```

**ADO.NET Connection String:**
```
Server=tcp:rentmedbserver.database.windows.net,1433;Initial Catalog=RentMeDb-Test;Persist Security Info=False;User ID=reduser;Password=Redemption2#;MultipleActiveResultSets=False;Encrypt=true;TrustServerCertificate=False;Connection Timeout=30;
```

### 2. RentMeDb (Production Database)
- **Edition**: Standard
- **Status**: Online
- **Purpose**: Production environment

**Connection String:**
```
Server=tcp:rentmedbserver.database.windows.net,1433;
Initial Catalog=RentMeDb;
User ID=reduser;
Password=Redemption2#;
Encrypt=true;
TrustServerCertificate=False;
Connection Timeout=30;
```

**ADO.NET Connection String:**
```
Server=tcp:rentmedbserver.database.windows.net,1433;Initial Catalog=RentMeDb;Persist Security Info=False;User ID=reduser;Password=Redemption2#;MultipleActiveResultSets=False;Encrypt=true;TrustServerCertificate=False;Connection Timeout=30;
```

### 3. RentMeBlogDb (Blog Database)
- **Edition**: Basic
- **Status**: Online
- **Purpose**: Blog/CMS content

**Connection String:**
```
Server=tcp:rentmedbserver.database.windows.net,1433;
Initial Catalog=RentMeBlogDb;
User ID=reduser;
Password=Redemption2#;
Encrypt=true;
TrustServerCertificate=False;
Connection Timeout=30;
```

**ADO.NET Connection String:**
```
Server=tcp:rentmedbserver.database.windows.net,1433;Initial Catalog=RentMeBlogDb;Persist Security Info=False;User ID=reduser;Password=Redemption2#;MultipleActiveResultSets=False;Encrypt=true;TrustServerCertificate=False;Connection Timeout=30;
```

## Azure App Services

The following App Services are running and use these databases:

1. **rentme** - https://rentme.azurewebsites.net (Running)
2. **rentme-blog-api** - https://rentme-blog-api.azurewebsites.net (Running)
3. **rentme-shortlinks** - https://rentme-shortlinks.azurewebsites.net (Running)

## Local Development

For local development, the following connection strings are used:

### LocalDB Connection:
```
Server=.;Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=RentMeDb;Integrated Security=True;Application Name=RentMe
```

### Azure Storage Emulator:
```
UseDevelopmentStorage=true
```

## Azure Blob Storage

### Test/Development Storage:
- **Account Name**: rentmeimagestest
- **Connection String**: See Web.Release.Test.config

### Production Storage:
- **Account Name**: rentmeimages
- **Connection String**: See Web.Release.config

## Access Permissions

**Current Azure Account**: aaron@onrentme.com

**Limitations**:
- ❌ Cannot read App Service connection strings/settings
- ❌ Cannot update SQL server passwords
- ❌ Cannot access Graph API for role assignments
- ✅ Can list databases and servers
- ✅ Can read database metadata

**Required Roles for Full Access**:
- Contributor or Owner role on the subscription
- SQL Server Contributor for database management
- Website Contributor for App Service configuration

## Configuration File Locations

Password and connection information was found in:
- `/Production/RentMe/Web.config` (line 17 - commented connection string)
- `/Production/RentMe/Web.Release.config` (production transform)
- `/Production/RentMe/Web.Release.Test.config` (test/staging transform)
- `/Dev/RentMe/Web.config` (development configuration)

## Security Notes

⚠️ **Important**: The password `Redemption2#` is currently stored in plaintext in configuration files. Consider:
1. Using Azure Key Vault for secure password storage
2. Implementing Managed Identity for Azure resources
3. Rotating the SQL admin password regularly
4. Using Azure App Service connection strings instead of web.config

## Azure CLI Commands

To retrieve this information again:

```bash
# Login to Azure
az login

# List databases
az sql db list --server rentmedbserver --resource-group RentMe-ResourceGroup -o table

# Get connection string template
az sql db show-connection-string --client ado.net --name RentMeDb-Test --server rentmedbserver

# List App Services
az webapp list --resource-group RentMe-ResourceGroup -o table
```

---
*Last Updated: 2025-10-04*
*Retrieved using Azure CLI 2.77.0*
