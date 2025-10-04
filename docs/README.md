# RentMe Documentation

Complete technical documentation for the RentMe rental property management platform.

**Status**: Well-architected legacy application requiring modernization
**Stack**: .NET Framework 4.6.1, AngularJS 1.5, SQL Server, Azure
**Last Updated**: October 4, 2025

---

## 📋 Quick Navigation

### For Executives
- **[Executive Summary](01-overview/executive-summary.md)** - Business case, costs, risks, and recommendations

### For Developers
- **[Setup Guide](02-getting-started/setup-guide.md)** - Get started with .NET development
- **[Code Examples](10-development/code-examples.md)** - Common patterns and implementations

### For Architects
- **[System Design](03-architecture/system-design.md)** - Architecture patterns and best practices
- **[Technical Debt](12-modernization/technical-debt.md)** - Current issues and improvements needed

---

## 📚 Documentation Sections

### 01. Overview
- **[Executive Summary](01-overview/executive-summary.md)** - TL;DR for C-suite: costs, timeline, risks
- **[System Overview](01-overview/system-overview.md)** - Technology stack and architecture

### 02. Getting Started
- **[Setup Guide](02-getting-started/setup-guide.md)** - .NET fundamentals, project structure, dev environment

### 03. Architecture
- **[System Design](03-architecture/system-design.md)** - Layered architecture, dependencies, best practices

### 04. Backend (C# / .NET)
- **[API Services](04-backend/api-services.md)** - Controllers, services, DI, background jobs

### 05. Data Layer
- **[Database](05-data/database.md)** - Database architecture and design
- **[Models](05-data/models.md)** - Data models and relationships
- **[Schema](05-data/schema.md)** - Complete database schema
- **[Entity Framework](05-data/entity-framework.md)** - EF patterns, LINQ, migrations

### 06. Frontend (AngularJS)
- **[AngularJS SPA](06-frontend/angularjs-spa.md)** - Components, services, routing, build

### 07. Features
- **[Core Features](07-features/core-features.md)** - Users, properties, applications
- **[Business Features](07-features/business-features.md)** - Leases, billing, payments, maintenance

### 08. Integrations
- **[Third-Party Services](08-integrations/third-party-services.md)** - Payment, credit, email, Azure

### 09. API Reference
- **[Endpoints](09-api-reference/endpoints.md)** - Complete API documentation

### 10. Development
- **[Code Examples](10-development/code-examples.md)** - Backend and frontend patterns
- **[Testing](10-development/testing.md)** - Unit, integration, E2E tests

### 11. Infrastructure
- **[Deployment](11-infrastructure/deployment.md)** - Azure, CI/CD, monitoring, security

### 12. Modernization
- **[Technical Debt](12-modernization/technical-debt.md)** - Six-environment problem, async/await, etc.
- **[Migration Roadmap](12-modernization/migration-roadmap.md)** - 5-phase modernization plan

---

## 🚨 Critical Information

### Technology Stack
- **Backend**: ASP.NET Web API 2 (.NET Framework 4.6.1)
- **Frontend**: AngularJS 1.5 (End of Life - 2022)
- **Database**: SQL Server with Entity Framework 6
- **Cloud**: Microsoft Azure (Web Apps, Functions, Blob Storage)
- **Total Code**: ~200,000 lines across 1,027 C# files and 275 JS files

### Key Statistics
- 38 distinct C# projects (DLLs/assemblies)
- 27 API controllers with 200+ endpoints
- 84 service classes with business logic
- 279 data model files
- 318 database migrations
- 17 scheduled background jobs

### Modernization Priority (High → Low)
1. 🔴 **CRITICAL**: Consolidate six environment folders → Git branches (1-3 months)
2. 🔴 **CRITICAL**: Replace AngularJS 1.5 → React 18 (6-9 months)
3. 🔴 **CRITICAL**: Upgrade .NET Framework 4.6.1 → .NET 8 (4-8 months)
4. 🟠 **HIGH**: Implement async/await throughout (2-4 months)
5. 🟡 **MEDIUM**: Increase test coverage to 80%+ (3-6 months)

**Total Effort**: 12-15 months | **Team**: 3-5 engineers | **Budget**: $1.0M

---

## 🎯 Common Tasks

### Find Something Quickly
- **User authentication**: [API Services](04-backend/api-services.md#authentication)
- **Database queries**: [Entity Framework](05-data/entity-framework.md#querying)
- **API endpoint list**: [Endpoints](09-api-reference/endpoints.md)
- **Payment processing**: [Third-Party Services](08-integrations/third-party-services.md#payments)
- **Deployment pipeline**: [Deployment](11-infrastructure/deployment.md#cicd)

### Understand the System
- **New to .NET?** Start with [Setup Guide](02-getting-started/setup-guide.md)
- **Need examples?** See [Code Examples](10-development/code-examples.md)
- **Architecture questions?** Read [System Design](03-architecture/system-design.md)
- **Feature documentation?** Check [Core Features](07-features/core-features.md) and [Business Features](07-features/business-features.md)

### Plan Modernization
1. Read [Executive Summary](01-overview/executive-summary.md) for business case
2. Review [Technical Debt](12-modernization/technical-debt.md) for current issues
3. Study [Migration Roadmap](12-modernization/migration-roadmap.md) for execution plan

---

## 📖 Documentation Standards

### File Organization
- Files are organized by domain (overview, backend, frontend, etc.)
- Each file is self-contained but includes cross-references
- Maximum ~500 lines per file for readability

### Code Examples
- All code examples include explanations
- Comparisons with modern equivalents (React, .NET 8, TypeScript)
- Real code from the RentMe codebase where possible

### Maintenance
- Keep documentation in sync with code changes
- Update version numbers and dates in file headers
- Review quarterly for accuracy

---

## 🔗 Related Resources

### External Documentation
- [ASP.NET Web API 2](https://docs.microsoft.com/en-us/aspnet/web-api/)
- [Entity Framework 6](https://docs.microsoft.com/en-us/ef/ef6/)
- [AngularJS 1.x](https://docs.angularjs.org/guide)
- [Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/)

### Migration Guides
- [.NET Framework to .NET 8 Migration](https://docs.microsoft.com/en-us/dotnet/core/porting/)
- [AngularJS to React Migration](https://react.dev/learn/thinking-in-react)

---

**Document Version**: 2.0
**Last Updated**: October 4, 2025
**Maintained By**: Engineering Team
