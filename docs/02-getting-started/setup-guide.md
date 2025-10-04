# Setup Guide

**Audience**: Developers new to C#/.NET and the RentMe codebase
**Last Updated**: October 4, 2025

---

## Table of Contents

1. [Understanding .NET and C# (For Beginners)](#understanding-net-and-c-for-beginners)
2. [Project Structure Overview](#project-structure-overview)
3. [Development Environment Setup](#development-environment-setup)
4. [Running the Application Locally](#running-the-application-locally)
5. [Common Development Tasks](#common-development-tasks)

---

## Understanding .NET and C# (For Beginners)

### What is .NET?

**.NET Framework** is Microsoft's application development platform, similar to how Java has the JVM ecosystem. Think of it as:

- **Java** → Spring Boot, Hibernate, Maven
- **.NET** → ASP.NET, Entity Framework, NuGet

### Key .NET Concepts

#### 1. **Solution (.sln) and Projects (.csproj)**

In .NET, code is organized differently than Node.js or Python:

```
Comparison with Node.js:
┌─────────────────────────────────┬─────────────────────────────────┐
│ Node.js                         │ .NET                            │
├─────────────────────────────────┼─────────────────────────────────┤
│ package.json (one per project)  │ RentMe.sln (entire solution)    │
│                                 │ ├─ RentMe.csproj (API project)  │
│                                 │ ├─ RentMe.Data.csproj           │
│ src/ folder structure           │ └─ RentMe.Common.csproj         │
│                                 │                                 │
│ node_modules/                   │ packages/ (NuGet packages)      │
│ npm install                     │ NuGet restore                   │
└─────────────────────────────────┴─────────────────────────────────┘
```

**Solution File** (`.sln`): A container that groups multiple related projects
- Similar to a monorepo workspace (Lerna, Nx, Turborepo)
- Example: `RentMe.sln` contains 38 projects

**Project File** (`.csproj`): Individual library or application
- Similar to a `package.json` for a single npm package
- Compiles to a DLL (library) or EXE (executable)

#### 2. **Namespaces and Assembly References**

```csharp
// Similar to JavaScript imports
using System;                      // like: import * as something from 'module'
using System.Linq;                 // like: import { specific } from 'lodash'
using RentMe.Data.Entities;        // like: import { Property } from './entities'

namespace RentMe.Web.Api.Controllers  // like: export namespace Controllers
{
    public class PropertiesController  // like: export class PropertiesController
    {
        // Controller code
    }
}
```

#### 3. **Dependency Injection Container**

.NET uses **IoC (Inversion of Control)** containers similar to:
- **Node.js**: InversifyJS, Awilix
- **Python**: dependency-injector
- **Java**: Spring IoC

**RentMe uses Autofac** (similar to Angular's DI system):

```csharp
// Registration (like configuring providers in Angular)
builder.RegisterType<PropertyService>()
    .As<IPropertyService>()
    .InstancePerRequest();  // Creates new instance per HTTP request

// Injection (like constructor injection in Angular/NestJS)
public class PropertiesController : ApiController
{
    private readonly IPropertyService _propertyService;

    public PropertiesController(IPropertyService propertyService)  // Injected automatically
    {
        _propertyService = propertyService;
    }
}
```

#### 4. **Entity Framework (ORM)**

Entity Framework is .NET's **ORM** (Object-Relational Mapper), similar to:
- **Node.js**: TypeORM, Sequelize, Prisma
- **Python**: SQLAlchemy, Django ORM
- **PHP**: Doctrine, Eloquent

```csharp
// Similar to TypeORM/Sequelize
public class ApplicationDbContext : DbContext  // like: export class AppDataSource
{
    public DbSet<Property> Properties { get; set; }  // like: @Entity() class Property
    public DbSet<User> Users { get; set; }
}

// Query examples
var properties = _context.Properties
    .Where(p => p.IsActive)           // .filter() in JS
    .OrderBy(p => p.Price)            // .sort() in JS
    .Skip(10)                         // .slice(10) in JS
    .Take(20)                         // .slice(0, 20) in JS
    .ToList();                        // Execute query
```

#### 5. **ASP.NET Web API vs Express.js**

```javascript
// Express.js
app.get('/api/properties', async (req, res) => {
    const properties = await propertyService.getAll();
    res.json(properties);
});
```

```csharp
// ASP.NET Web API
[Route("api/properties")]
[HttpGet]
public IHttpActionResult GetProperties()
{
    var properties = _propertyService.GetAll();
    return Ok(properties);  // Returns JSON automatically
}
```

---

## Project Structure Overview

### Root Directory Structure

```
RentMe/
├── Production/          ⭐ CANONICAL SOURCE - Live production code
├── Dev/                 🔧 Main development environment
├── Dev-Design/          🎨 UI/UX design feature branch
├── Dev-Payments/        💳 Payment integration feature branch
├── Dev-Rent/            🏠 Core rental features branch
├── Dev-ShareAble/       📊 Credit reporting feature branch
├── BuildProcessTemplates/  Azure DevOps build templates
├── doc/                 📚 Documentation (including README.md)
└── docs/                📚 Additional documentation
```

### Production Folder Contents (38 Projects)

```
Production/
├── RentMe.sln                          ⭐ MAIN SOLUTION (all projects)
├── RentMe-Server.sln                   🔧 Backend-only solution
├── RentMe-Client.sln                   🎨 Frontend-only solution
├── RentMe-Functions.sln                ⚡ Azure Functions solution
├── RentMe-ShortLinks.sln               🔗 URL shortener solution
│
├── 🌐 WEB/API PROJECTS (User-Facing)
│   ├── RentMe/                         ⭐ MAIN WEB API (RESTful backend)
│   ├── RentMe.Web.SPA/                 🎨 MAIN FRONTEND (AngularJS SPA)
│   ├── RentMe.Web.BlogApi/             📝 Blog/CMS API (Piranha CMS)
│   ├── RentMe.Web.ShortLinksApp/       🔗 URL shortener service
│   └── RentMe.Web.Prerender/           🔍 SEO pre-rendering service
│
├── 📊 DATA & MODELS
│   ├── RentMe.Data/                    🗄️  Entity Framework DbContext, entities, migrations
│   ├── RentMe.Web.Models/              📋 API request/response DTOs
│   └── RentMe.Web.Common/              🔧 Shared web utilities
│
├── 🧩 CORE LIBRARIES
│   ├── RentMe.Common/                  🔧 Shared utilities, constants, extensions
│   ├── RentMe.Utilities/               🛠️  Helper functions, converters
│   └── RentMe.Logging/                 📝 Logging abstraction layer
│
├── ☁️ AZURE FUNCTIONS (Serverless Background Jobs)
│   ├── RentMe.AzureFunctions/          ⚡ Main functions project
│   └── RentMe.AzureFunctions.Common/   🔧 Shared function utilities
│
├── 🔌 THIRD-PARTY INTEGRATIONS
│   ├── RentMe.ProfitStarsIntegration/      💰 ACH payments (Jack Henry)
│   ├── RentMe.TransUnionShareAble/         📊 Credit reporting (TransUnion)
│   ├── RentMe.SureAppIntegration/          🛡️  Renters insurance (SureApp)
│   ├── RentMe.MailChimp/                   📧 Email marketing
│   └── RentMe.ImageProcessing/             🖼️  Image optimization
│
└── ✅ TEST PROJECTS
    ├── RentMe.Tests.Common/            🧪 Shared test utilities
    ├── RentMe.Common.Tests/            ✅ Unit tests for common lib
    ├── RentMe.Utilities.Tests/         ✅ Unit tests for utilities
    ├── RentMe.Web.Api.Tests/           ✅ API integration tests
    ├── RentMe.Web.SPA.Tests/           ✅ Frontend unit tests
    ├── RentMe.ProfitStarsIntegration.Tests/
    ├── RentMe.SureAppIntegration.Tests/
    └── RentMe.ImageProcessing.Tests/
```

---

## Development Environment Setup

### Prerequisites

**Required Tools**:
- Visual Studio 2019 or later (Community, Professional, or Enterprise)
- .NET Framework 4.6.1 SDK
- SQL Server 2016 or later (or SQL Server Express)
- Node.js 14+ and npm (for AngularJS frontend)
- Git for version control

**Optional but Recommended**:
- Visual Studio Code (for frontend development)
- Azure Storage Explorer (for blob storage)
- Postman or Insomnia (for API testing)
- SQL Server Management Studio (SSMS)

### Step 1: Clone the Repository

```bash
# Clone repository
git clone https://your-repo-url/rentme.git
cd rentme

# Navigate to Production folder (canonical source)
cd Production
```

### Step 2: Database Setup

1. **Create Database**:
```sql
-- In SQL Server Management Studio
CREATE DATABASE RentMe_Dev;
GO
```

2. **Update Connection String**:
```xml
<!-- In Production/RentMe/Web.config -->
<connectionStrings>
    <add name="DefaultConnection"
         connectionString="Server=(localdb)\mssqllocaldb;Database=RentMe_Dev;Trusted_Connection=True;"
         providerName="System.Data.SqlClient" />
</connectionStrings>
```

3. **Run Migrations**:
```bash
# In Package Manager Console (Visual Studio)
Update-Database -Project RentMe.Data
```

### Step 3: Backend Setup (API)

1. **Open Solution**:
   - Open `Production/RentMe.sln` in Visual Studio

2. **Restore NuGet Packages**:
   - Right-click on solution → "Restore NuGet Packages"
   - Or use Package Manager Console: `dotnet restore`

3. **Build Solution**:
   - Build → Build Solution (Ctrl+Shift+B)
   - Fix any compilation errors

4. **Configure App Settings**:
```xml
<!-- Production/RentMe/Web.config -->
<appSettings>
    <!-- Azure Storage -->
    <add key="AzureStorageConnectionString" value="UseDevelopmentStorage=true" />

    <!-- SendGrid -->
    <add key="SendGridApiKey" value="your-dev-key-here" />

    <!-- Braintree (use sandbox) -->
    <add key="BraintreeEnvironment" value="sandbox" />
    <add key="BraintreeMerchantId" value="your-sandbox-merchant-id" />
    <add key="BraintreePublicKey" value="your-sandbox-public-key" />
    <add key="BraintreePrivateKey" value="your-sandbox-private-key" />
</appSettings>
```

### Step 4: Frontend Setup (SPA)

1. **Navigate to SPA Project**:
```bash
cd Production/RentMe.Web.SPA
```

2. **Install Dependencies**:
```bash
npm install
```

3. **Configure API Base URL**:
```javascript
// In app.js or config file
angular.module('RentMeApp')
    .constant('API_BASE_URL', 'http://localhost:13262');  // Local API URL
```

4. **Build Frontend**:
```bash
# For development (with watch)
npm run dev

# For production build
npm run build
```

### Step 5: Azure Storage Emulator (Optional)

For local development with image uploads:

1. **Install Azure Storage Emulator**:
   - Download from Microsoft website
   - Or use Azurite (newer alternative)

2. **Start Emulator**:
```bash
# Storage Emulator
AzureStorageEmulator.exe start

# Or Azurite
azurite --silent --location c:\azurite --debug c:\azurite\debug.log
```

---

## Running the Application Locally

### Running Backend (API)

**Option 1: Visual Studio**
1. Set `RentMe` as startup project
2. Press F5 or click "Start Debugging"
3. API will launch at `http://localhost:13262`

**Option 2: Command Line**
```bash
cd Production/RentMe
dotnet run
```

### Running Frontend (SPA)

**Option 1: IIS Express (Visual Studio)**
1. Set `RentMe.Web.SPA` as startup project
2. Press F5
3. Browser will open at configured URL

**Option 2: Local Development Server**
```bash
cd Production/RentMe.Web.SPA
npm run dev
# Opens at http://localhost:3000
```

### Running Both Simultaneously

**Visual Studio Multi-Startup**:
1. Right-click solution → Properties
2. Startup Project → Multiple startup projects
3. Set both `RentMe` and `RentMe.Web.SPA` to "Start"
4. Press F5

---

## Common Development Tasks

### Adding a New API Endpoint

1. **Create Model** (if needed):
```csharp
// Production/RentMe.Web.Models/PropertyModels.cs
public class CreatePropertyModel
{
    [Required]
    public string Address { get; set; }

    [Required]
    public decimal Rent { get; set; }
}
```

2. **Add Service Method**:
```csharp
// Production/RentMe/Services/PropertyService.cs
public interface IPropertyService
{
    Property CreateProperty(CreatePropertyModel model, string userId);
}

public class PropertyService : IPropertyService
{
    public Property CreateProperty(CreatePropertyModel model, string userId)
    {
        // Implementation
    }
}
```

3. **Add Controller Action**:
```csharp
// Production/RentMe/Controllers/PropertiesController.cs
[HttpPost]
[Route("")]
public IHttpActionResult CreateProperty(CreatePropertyModel model)
{
    if (!ModelState.IsValid)
        return BadRequest(ModelState);

    var userId = User.Identity.GetUserId();
    var property = _propertyService.CreateProperty(model, userId);

    return CreatedAtRoute("GetPropertyById", new { id = property.Id }, property);
}
```

### Running Database Migrations

**Create New Migration**:
```bash
# Package Manager Console
Add-Migration AddNewPropertyField -Project RentMe.Data
```

**Apply Migration to Database**:
```bash
Update-Database -Project RentMe.Data
```

**Rollback Migration**:
```bash
Update-Database -TargetMigration PreviousMigrationName -Project RentMe.Data
```

### Running Tests

**Visual Studio Test Explorer**:
1. Test → Test Explorer
2. Run All Tests
3. View results

**Command Line**:
```bash
# Run all tests
dotnet test

# Run specific test project
dotnet test RentMe.Web.Api.Tests/RentMe.Web.Api.Tests.csproj
```

### Debugging Tips

**Backend Debugging**:
- Set breakpoints in C# code
- Press F5 to start debugging
- Use Watch window, Immediate window, Call Stack

**Frontend Debugging**:
- Use browser DevTools (F12)
- Set breakpoints in JavaScript
- Use `console.log()` for debugging
- AngularJS Batarang extension for Chrome

**Common Issues**:

1. **Port Already in Use**:
   - Kill process using the port
   - Or change port in project properties

2. **Database Connection Errors**:
   - Verify SQL Server is running
   - Check connection string
   - Ensure database exists

3. **NuGet Restore Fails**:
   - Clear NuGet cache: `nuget locals all -clear`
   - Restore packages: `nuget restore`

4. **Frontend Build Errors**:
   - Delete `node_modules`
   - Run `npm install` again
   - Check Node.js version compatibility

---

## Next Steps

Once your development environment is set up:

1. Review the [System Design documentation](../03-architecture/system-design.md) to understand the architecture
2. Explore the [Technical Debt documentation](../12-modernization/technical-debt.md) to understand current limitations
3. Review the [Migration Roadmap](../12-modernization/migration-roadmap.md) for future improvements
4. Start with small changes to familiarize yourself with the codebase

---

**Document Version**: 1.0
**Last Updated**: October 4, 2025
**Maintained By**: Engineering Team
