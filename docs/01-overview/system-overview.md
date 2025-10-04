# RentMe System Overview

**Last Updated**: October 4, 2025

## Executive Summary

**RentMe** is a comprehensive rental property management platform built as a **multi-tier web application** using the **.NET Framework**. The application consists of:

- **Backend**: ASP.NET Web API 2 (.NET Framework 4.6.1) - RESTful API
- **Frontend**: AngularJS 1.5 Single Page Application (SPA)
- **Database**: SQL Server with Entity Framework 6 ORM
- **Cloud**: Microsoft Azure (Web Apps, Functions, Blob Storage, SQL Database)
- **Total Code**: 1,027 C# files, 275 JavaScript files, ~200,000+ lines of code

## Key Statistics

- **38 distinct C# projects** (DLLs/assemblies)
- **27 API controllers** handling 200+ endpoints
- **84 service classes** containing business logic
- **279 data model files**
- **318 database migrations**
- **17 scheduled background jobs**
- **50+ database tables**

**Overall Assessment**: Well-architected legacy application with solid engineering principles, but built on outdated technology stack. Requires modernization.

---

## Technology Stack

### Backend Technologies (C# / .NET)

| Component | Technology | Version | Purpose | npm Equivalent |
|-----------|-----------|---------|---------|----------------|
| **Framework** | ASP.NET Web API 2 | .NET 4.6.1 | RESTful API framework | Express.js, Fastify |
| **ORM** | Entity Framework | 6.2.0 | Database access | TypeORM, Sequelize, Prisma |
| **DI Container** | Autofac | 4.6.2 | Dependency injection | InversifyJS, Awilix |
| **Mapping** | AutoMapper | 6.2.2 | Object-to-object mapping | class-transformer |
| **Background Jobs** | Hangfire | 1.6.17 | Scheduled tasks | node-cron, Bull, Agenda |
| **Authentication** | ASP.NET Identity | 2.2.1 | User management | Passport.js, Auth0 |
| **OAuth** | OWIN | 3.1.0 | Bearer tokens | passport-jwt, jsonwebtoken |
| **Validation** | FluentValidation | 7.6.104 | Model validation | Joi, Yup, class-validator |
| **Logging** | Custom + App Insights | - | Structured logging | Winston, Pino, Bunyan |
| **Testing** | xUnit | 2.3.1 | Unit testing | Jest, Mocha |
| **Mocking** | Moq | 4.8.2 | Test doubles | Sinon.js, jest.mock |

### Frontend Technologies (JavaScript)

| Component | Technology | Version | Purpose | Modern Equivalent |
|-----------|-----------|---------|---------|-------------------|
| **Framework** | AngularJS | 1.5.11 | SPA framework | React 18, Vue 3, Angular 17 |
| **Router** | UI-Router | 1.0.13 | Client routing | React Router, Vue Router |
| **UI Components** | UI Bootstrap | 2.5.6 | Bootstrap for Angular | Material UI, Ant Design |
| **Build Tool** | Grunt | 1.0.1 | Task runner | Webpack, Vite, Rollup |
| **CSS** | SASS | - | Preprocessing | Same (or PostCSS, Tailwind) |
| **HTTP** | $http service | Built-in | AJAX calls | Axios, Fetch API |
| **File Upload** | ng-file-upload | 12.0.4 | File handling | react-dropzone, vue-upload |
| **Maps** | ngMap | 1.18.4 | Google Maps | @react-google-maps/api |
| **Charts** | ApexCharts | 3.6.7 | Data visualization | Same, or Chart.js, D3.js |
| **Utilities** | Lodash | 4.x | Helpers | Same |

### Cloud & Infrastructure

| Service | Technology | Purpose |
|---------|-----------|---------|
| **Hosting** | Azure Web Apps | Application hosting |
| **Serverless** | Azure Functions | Background processing |
| **Database** | Azure SQL Database | Relational data storage |
| **Storage** | Azure Blob Storage | Files, images, documents |
| **CDN** | Azure CDN | Static asset delivery |
| **Monitoring** | Application Insights | APM, logging, metrics |
| **CI/CD** | Azure DevOps (TFS) | Build and deployment |
| **Version Control** | TFVC → Git | Source control |

---

## Third-Party Services

| Service | Provider | Purpose |
|---------|----------|---------|
| **Payments (CC)** | Braintree | Credit card processing |
| **Payments (ACH)** | ProfitStars (Jack Henry) | Bank transfers |
| **Credit Checks** | TransUnion SmartMove | Tenant screening |
| **Credit Reporting** | TransUnion ShareAble | Rent payment reporting |
| **Insurance** | SureApp | Renters insurance |
| **Email** | SendGrid | Transactional emails |
| **SMS** | Telnyx | Text messaging |
| **Marketing** | MailChimp | Email campaigns |
| **Syndication** | Zillow/HotPads | Listing distribution |
| **CMS** | Piranha CMS | Blog content |

---

## High-Level Architecture

### Layered Architecture Pattern

RentMe follows a **classic N-tier architecture**, similar to:
- **Node.js**: Controller → Service → Repository → Database
- **Java Spring**: Controller → Service → Repository → Entity
- **Rails**: Controller → Model → Database

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌──────────────────────┐      ┌──────────────────────┐    │
│  │ AngularJS SPA        │      │ ASP.NET Web API      │    │
│  │ (RentMe.Web.SPA)     │ HTTP │ (RentMe)             │    │
│  │ - Components         │◄────►│ - Controllers        │    │
│  │ - Services           │ JSON │ - Model Binding      │    │
│  │ - Views              │      │ - Authentication     │    │
│  └──────────────────────┘      └──────────┬───────────┘    │
└─────────────────────────────────────────────┼───────────────┘
                                              │
┌─────────────────────────────────────────────┼───────────────┐
│                    BUSINESS LOGIC LAYER     │               │
│  ┌──────────────────────────────────────────▼──────────┐    │
│  │ Services (RentMe/Services/*.cs)                     │    │
│  │ ┌─────────────┐ ┌──────────────┐ ┌──────────────┐  │    │
│  │ │PropertySvc  │ │BillingSvc    │ │AccountSvc    │  │    │
│  │ │- Create     │ │- Generate    │ │- Register    │  │    │
│  │ │- Update     │ │- Calculate   │ │- Login       │  │    │
│  │ │- Delete     │ │- Process     │ │- Verify      │  │    │
│  │ └─────────────┘ └──────────────┘ └──────────────┘  │    │
│  └──────────────────────────┬───────────────────────────┘    │
│                             │                               │
│  ┌─────────────────────────▼────────────────────────────┐    │
│  │ Managers (Cross-Cutting Concerns)                    │    │
│  │ - IAccessManager (Authorization)                     │    │
│  │ - IPhotoManager (Image handling)                     │    │
│  │ - IEmailManager (Notifications)                      │    │
│  └──────────────────────────┬───────────────────────────┘    │
└─────────────────────────────┼───────────────────────────────┘
                              │
┌─────────────────────────────┼───────────────────────────────┐
│                    DATA ACCESS LAYER        │               │
│  ┌──────────────────────────▼──────────────────────────┐    │
│  │ Entity Framework (RentMe.Data)                      │    │
│  │ ┌──────────────────────────────────────────────┐    │    │
│  │ │ ApplicationDbContext : DbContext             │    │    │
│  │ │                                              │    │    │
│  │ │ DbSet<Property> Properties                   │    │    │
│  │ │ DbSet<User> Users                            │    │    │
│  │ │ DbSet<Billing> Billings                      │    │    │
│  │ │ DbSet<Lease> Leases                          │    │    │
│  │ │ (30+ DbSets)                                 │    │    │
│  │ └────────────────────┬─────────────────────────┘    │    │
│  └──────────────────────┼─────────────────────────────┘    │
└─────────────────────────┼───────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────┐
│                    DATABASE LAYER                           │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Microsoft SQL Server                                 │   │
│  │ - 50+ tables                                         │   │
│  │ - Foreign key relationships                          │   │
│  │ - Indexes for performance                            │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Project Dependency Graph

```
RentMe.Web.SPA (Frontend)
    │
    └─── HTTP/JSON ───┐
                      │
RentMe (Web API) ◄────┘
    │
    ├──► RentMe.Web.Models (DTOs)
    ├──► RentMe.Web.Common (Web utilities)
    ├──► RentMe.Common (Shared code)
    ├──► RentMe.Utilities (Helpers)
    ├──► RentMe.Logging (Logging)
    ├──► RentMe.Data (EF, entities)
    │       │
    │       └──► RentMe.Common
    │
    ├──► RentMe.ProfitStarsIntegration
    │       └──► RentMe.Common
    │
    ├──► RentMe.TransUnionShareAble
    │       └──► RentMe.Common
    │
    ├──► RentMe.SureAppIntegration
    │       └──► RentMe.Common
    │
    ├──► RentMe.MailChimp
    │       └──► RentMe.Common
    │
    └──► RentMe.ImageProcessing
            └──► RentMe.Common
```

**Key Principle**: Dependencies flow **downward and inward**
- Web API depends on Data, not vice versa
- Integrations are isolated (can be swapped)
- Common libraries have no dependencies on higher layers

---

## Project Structure

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

## Comparison to Industry Standards (2025)

| Metric | RentMe (Current) | Industry Standard (2025) | Gap |
|--------|------------------|--------------------------|-----|
| **Frontend Framework** | AngularJS 1.5 (EOL 2022) | React 18, Vue 3, Angular 17 | 🔴 **8 years behind** |
| **Backend Framework** | .NET Framework 4.6.1 (2015) | .NET 8 (2023) | 🔴 **8 years behind** |
| **Test Coverage** | ~30% | 80%+ | 🟠 **50% gap** |
| **Deployment Pipeline** | Manual/semi-automated | Fully automated CI/CD | 🟡 **Partial** |
| **Performance (Page Load)** | 3-5 seconds | <1 second | 🔴 **3-5x slower** |
| **Deployment Flexibility** | Windows VMs only | Windows or Linux containers | 🟡 **Limited options** |

---

## What .NET Framework 4.6.1 vs .NET 8 Means

| Feature | .NET Framework 4.6.1 | .NET 8 |
|---------|---------------------|--------|
| **Performance** | Baseline | 3-5x faster |
| **Cross-platform** | Windows only | Windows, Linux, macOS |
| **Cloud-native** | Limited | Excellent |
| **Development** | Maintenance mode | Active development |
| **Long-term support** | No new features | LTS until Nov 2026 |
| **Container support** | Poor | Excellent |
| **Async performance** | Good | Excellent |

---

## Key Strengths

- ✅ Clean architecture with proper layering
- ✅ Comprehensive feature coverage (350+ features)
- ✅ Robust integration ecosystem
- ✅ Production Azure infrastructure
- ✅ Clear project organization
- ✅ Separation of concerns (Controllers → Services → Data)
- ✅ Dependency injection throughout
- ✅ Well-organized 38-project solution

---

## Critical Areas Requiring Attention

1. **🔴 AngularJS 1.5 (End of Life)**
   - No security patches since 2022
   - Shrinking developer talent pool
   - Performance limitations

2. **🔴 .NET Framework 4.6.1 (Legacy)**
   - Maintenance mode, no new features
   - 3-5x slower than .NET 8
   - Windows-only deployment

3. **🟠 Six Duplicate Codebases**
   - Massive merge conflicts
   - Configuration drift
   - Developer confusion

4. **🟠 Synchronous Code**
   - No async/await patterns
   - Poor scalability under load
   - Resource inefficiency

5. **🟡 Limited Test Coverage**
   - ~30% coverage vs 80%+ industry standard
   - High risk of regression bugs

---

## Document Information

**Document Version**: 1.0
**Last Updated**: October 4, 2025
**Related Documents**:
- [API Services Reference](../04-backend/api-services.md)
- [Frontend Architecture](../06-frontend/angularjs-spa.md)
- [Code Examples](../10-development/code-examples.md)
