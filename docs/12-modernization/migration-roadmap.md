# Modernization Roadmap

**Audience**: Engineering leadership, project managers, and technical architects
**Last Updated**: October 4, 2025

---

## Table of Contents

1. [Overview](#overview)
2. [Phase 1: Foundation (Months 1-3)](#phase-1-foundation-months-1-3)
3. [Phase 2: Backend Modernization (Months 4-8)](#phase-2-backend-modernization-months-4-8)
4. [Phase 3: Frontend Rewrite (Months 6-12)](#phase-3-frontend-rewrite-months-6-12)
5. [Phase 4: Testing & Quality (Months 10-12)](#phase-4-testing--quality-months-10-12)
6. [Phase 5: Deployment & Cutover (Month 12)](#phase-5-deployment--cutover-month-12)
7. [Timeline Summary](#timeline-summary)

---

## Overview

**Goal**: Transform RentMe from a legacy application to a modern, high-performance platform while maintaining business continuity.

**Approach**: Phased migration with parallel systems, gradual cutover, and zero-downtime deployment.

**Total Estimated Effort**: 12-15 months with 3-5 engineers

**Total Estimated Cost**: $1,010,000

**Key Principles**:
- ✅ Maintain business continuity (no downtime)
- ✅ Parallel systems during migration
- ✅ Incremental delivery (value every month)
- ✅ Reversible decisions (can rollback)
- ✅ Quality gates at each phase

---

## Phase 1: Foundation (Months 1-3)

**Goal**: Establish modern development practices and consolidate infrastructure

**Cost**: $150K | **Risk**: Low | **Business Impact**: High

### 1.1 Environment Consolidation

**Objective**: Consolidate six environment folders into single Git repository

**Tasks**:
- [ ] Choose canonical source (recommend: Production)
- [ ] Create new Git repository
- [ ] Initialize Git with .gitignore for .NET
- [ ] Commit Production folder as initial commit
- [ ] Create feature branches for Dev-* differences
- [ ] Archive old environment folders
- [ ] Update team documentation

**Tools**:
```bash
# Initialize Git
git init
git add .
git commit -m "Initial commit - Production codebase"

# Create feature branches
git checkout -b feature/payment-enhancements
git checkout -b feature/shareAble-integration
git checkout -b feature/ui-redesign
```

**Deliverables**:
- ✅ Single source of truth in Git
- ✅ Feature branches for active work
- ✅ Archived old environment folders
- ✅ Updated team documentation

**Timeline**: 3 weeks

**Success Metrics**:
- All code in single repository
- Zero deployment from old folders
- Developer onboarding time reduced by 50%

### 1.2 CI/CD Pipeline Setup

**Objective**: Implement modern CI/CD pipeline with automated testing

**Tasks**:
- [ ] Migrate from TFVC to Git in Azure DevOps
- [ ] Create build pipeline (YAML-based)
- [ ] Create release pipeline
- [ ] Set up environments (Dev, Staging, Production)
- [ ] Implement automated testing in pipeline
- [ ] Add code quality gates (SonarQube)

**Example**: `azure-pipelines.yml`
```yaml
trigger:
  branches:
    include:
      - main
      - develop

pool:
  vmImage: 'windows-latest'

stages:
  - stage: Build
    jobs:
      - job: BuildBackend
        steps:
          - task: NuGetRestore@2
          - task: VSBuild@1
            inputs:
              solution: 'RentMe.sln'
          - task: VSTest@2
            inputs:
              testAssemblyVer2: '**/*Tests.dll'

  - stage: Deploy
    dependsOn: Build
    jobs:
      - deployment: DeployToAzure
        environment: 'Production'
        strategy:
          runOnce:
            deploy:
              steps:
                - task: AzureWebApp@1
```

**Deliverables**:
- ✅ Automated build pipeline
- ✅ Automated deployment to Dev/Staging
- ✅ Automated test execution
- ✅ Code quality reports

**Timeline**: 2 weeks

**Success Metrics**:
- Deployments automated (no manual steps)
- Build time <10 minutes
- Zero failed deployments to Staging

### 1.3 Database Modernization

**Objective**: Optimize database performance and document schema

**Tasks**:
- [ ] Audit current database (50+ tables)
- [ ] Identify unused columns/tables
- [ ] Add missing indexes (query analysis)
- [ ] Create database backup strategy
- [ ] Document schema with tools (DbSchema, SQL Doc)

**Example**: Index optimization
```sql
-- Add index for common query
CREATE NONCLUSTERED INDEX IX_Properties_City_State
ON Properties (City, State)
INCLUDE (Address, Rent, Bedrooms, Bathrooms)
WHERE IsActive = 1 AND IsDeleted = 0;

-- Add index for user properties lookup
CREATE NONCLUSTERED INDEX IX_Properties_UserId
ON Properties (UserId)
INCLUDE (Address, City, State, Rent)
WHERE IsActive = 1;
```

**Deliverables**:
- ✅ Database performance report
- ✅ Optimized indexes
- ✅ Automated backup strategy
- ✅ Schema documentation

**Timeline**: 2 weeks

**Success Metrics**:
- Query performance improved by 50%
- Database documentation complete
- Automated backups running daily

---

## Phase 2: Backend Modernization (Months 4-8)

**Goal**: Upgrade backend to .NET 8 with modern patterns

**Cost**: $300K | **Risk**: Medium | **Business Impact**: Very High

### 2.1 Upgrade to .NET 8

**Objective**: Migrate from .NET Framework 4.6.1 to .NET 8

**Tasks**:
- [ ] Create new .NET 8 projects (parallel to existing)
- [ ] Port RentMe.Data to .NET 8 + EF Core 8
- [ ] Port RentMe.Common to .NET 8
- [ ] Port RentMe.Web.Api to ASP.NET Core 8
- [ ] Implement async/await throughout
- [ ] Add Minimal APIs where appropriate
- [ ] Parallel run both APIs (feature flag)

**Migration Example**:
```csharp
// OLD: .NET Framework Web API
public class PropertiesController : ApiController
{
    [HttpGet]
    public IHttpActionResult GetProperties()
    {
        var properties = _service.GetAll();
        return Ok(properties);
    }
}

// NEW: .NET 8 Minimal API
app.MapGet("/api/properties", async (
    [FromServices] IPropertyService service,
    [FromQuery] int page = 0,
    [FromQuery] int take = 15) =>
{
    var properties = await service.GetAllAsync(page, take);
    return Results.Ok(properties);
})
.RequireAuthorization();
```

**Deliverables**:
- ✅ .NET 8 backend running in parallel
- ✅ All APIs migrated to async/await
- ✅ Performance benchmarks (3-5x improvement)
- ✅ Migration documentation

**Timeline**: 12 weeks

**Success Metrics**:
- API response time improved by 3-5x
- Memory usage reduced by 50%
- All endpoints using async/await

### 2.2 Add Modern Features

**Objective**: Implement modern API patterns and tools

**Tasks**:
- [ ] Implement Swagger/OpenAPI documentation
- [ ] Add GraphQL endpoint (optional, for mobile apps)
- [ ] Implement rate limiting
- [ ] Add request/response compression
- [ ] Implement CORS properly
- [ ] Add health checks
- [ ] Implement distributed caching (Redis)

**Example**: Swagger setup
```csharp
// Program.cs (.NET 8)
var builder = WebApplication.CreateBuilder(args);

// Add Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "RentMe API",
        Version = "v1",
        Description = "Rental property management platform API"
    });
});

var app = builder.Build();

// Use Swagger
app.UseSwagger();
app.UseSwaggerUI();

app.Run();
```

**Deliverables**:
- ✅ Interactive API documentation (Swagger)
- ✅ Health check endpoints
- ✅ Rate limiting configured
- ✅ Redis caching implemented

**Timeline**: 4 weeks

**Success Metrics**:
- API documentation 100% complete
- Cache hit rate >70%
- Rate limiting preventing abuse

### 2.3 Improve Code Quality

**Objective**: Increase test coverage and implement quality practices

**Tasks**:
- [ ] Implement global exception handler
- [ ] Add request validation with FluentValidation
- [ ] Implement structured logging (Serilog)
- [ ] Add Application Insights properly
- [ ] Increase test coverage to 80%+
- [ ] Add integration tests
- [ ] Add load tests

**Example**: Global exception handler
```csharp
// Middleware/GlobalExceptionHandler.cs
public class GlobalExceptionHandler : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(
        HttpContext httpContext,
        Exception exception,
        CancellationToken cancellationToken)
    {
        var (statusCode, message) = exception switch
        {
            NotFoundException => (404, exception.Message),
            ValidationException => (400, exception.Message),
            UnauthorizedException => (401, "Unauthorized"),
            _ => (500, "An error occurred processing your request")
        };

        await httpContext.Response.WriteAsJsonAsync(new
        {
            error = message,
            statusCode,
            traceId = Activity.Current?.Id
        }, cancellationToken);

        return true;
    }
}
```

**Deliverables**:
- ✅ Test coverage 80%+
- ✅ Global exception handling
- ✅ Structured logging
- ✅ Load test reports

**Timeline**: 4 weeks

**Success Metrics**:
- Unit test coverage >80%
- Integration test coverage >70%
- Zero unhandled exceptions in production

---

## Phase 3: Frontend Rewrite (Months 6-12)

**Goal**: Replace AngularJS 1.5 with React 18 + Next.js 14

**Cost**: $400K | **Risk**: Medium | **Business Impact**: Very High

### 3.1 Technology Selection

**Recommended Stack**: React 18 + Next.js 14 + TypeScript

**Rationale**:
- ✅ Largest ecosystem and hiring pool
- ✅ Server-side rendering for SEO
- ✅ File-based routing (like AngularJS UI-Router)
- ✅ API routes (backend-for-frontend)
- ✅ Excellent TypeScript support
- ✅ Vercel hosting (or Azure Static Web Apps)

### 3.2 Project Setup

```bash
# Create Next.js project
npx create-next-app@latest rentme-web --typescript --tailwind --app

# Install dependencies
npm install @tanstack/react-query axios zod react-hook-form
npm install @radix-ui/react-dialog @radix-ui/react-dropdown-menu
npm install lucide-react  # Icons
npm install date-fns  # Date utilities
npm install recharts  # Charts (instead of ApexCharts)
```

**Project Structure**:
```
rentme-web/
├── app/                          # Next.js app directory
│   ├── (auth)/                   # Auth layout group
│   │   ├── login/
│   │   └── register/
│   ├── (dashboard)/              # Dashboard layout group
│   │   ├── properties/
│   │   ├── billing/
│   │   ├── leases/
│   │   └── applications/
│   ├── layout.tsx                # Root layout
│   └── page.tsx                  # Home page
├── components/                   # Reusable components
│   ├── ui/                       # Base UI components
│   ├── properties/               # Property-specific
│   └── billing/                  # Billing-specific
├── lib/                          # Utilities
│   ├── api/                      # API client
│   ├── hooks/                    # Custom hooks
│   └── utils/                    # Helper functions
└── public/                       # Static assets
```

**Timeline**: 2 weeks

### 3.3 Migration Strategy: Strangler Fig Pattern

**Approach**: Incrementally replace AngularJS pages with React

**Step 1: Setup Proxy** (both apps running simultaneously)
```nginx
# nginx.conf
location /app {
    proxy_pass http://localhost:3000;  # Next.js
}

location / {
    proxy_pass http://localhost:13262;  # AngularJS
}
```

**Step 2: Migrate Page by Page**:
```
Week 1-2:  Login/Register → Next.js
Week 3-4:  Property Search → Next.js
Week 5-6:  Property Details → Next.js
Week 7-8:  Dashboard → Next.js
Week 9-10: Manage Properties → Next.js
Week 11-12: Billing → Next.js
Week 13-14: Leases → Next.js
Week 15-16: Applications → Next.js
Week 17-18: Maintenance → Next.js
Week 19-20: Reports → Next.js
Week 21-24: Remaining pages + polish
```

**Step 3: Shared Components Library**:
```typescript
// components/ui/button.tsx
import { cn } from '@/lib/utils';

export function Button({ children, variant = 'primary', ...props }) {
    return (
        <button
            className={cn(
                'px-4 py-2 rounded-md font-medium',
                variant === 'primary' && 'bg-blue-600 text-white hover:bg-blue-700',
                variant === 'secondary' && 'bg-gray-200 text-gray-900 hover:bg-gray-300'
            )}
            {...props}
        >
            {children}
        </button>
    );
}
```

**Timeline**: 24 weeks

**Success Metrics**:
- All pages migrated to React
- Performance improved 3-5x
- SEO score improved to 90+

### 3.4 API Client (React Query + Axios)

**Example**: Properties API client
```typescript
// lib/api/properties.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './client';

export interface Property {
    id: number;
    address: string;
    city: string;
    state: string;
    rent: number;
    bedrooms: number;
    bathrooms: number;
}

// GET list
export function useProperties(page = 0, take = 15, query?: string) {
    return useQuery({
        queryKey: ['properties', page, take, query],
        queryFn: async () => {
            const { data } = await api.get<Property[]>('/api/Properties', {
                params: { page, take, query }
            });
            return data;
        },
        staleTime: 1000 * 60 * 5  // Cache for 5 minutes
    });
}

// GET single
export function useProperty(id: number) {
    return useQuery({
        queryKey: ['property', id],
        queryFn: async () => {
            const { data } = await api.get<Property>(`/api/Properties/${id}`);
            return data;
        }
    });
}

// POST (create)
export function useCreateProperty() {
    const queryClient = useQueryClient();

    return useMutation({
        mutationFn: async (property: Omit<Property, 'id'>) => {
            const { data } = await api.post<Property>('/api/Properties', property);
            return data;
        },
        onSuccess: () => {
            // Invalidate cache
            queryClient.invalidateQueries({ queryKey: ['properties'] });
        }
    });
}
```

**Usage in Component**:
```typescript
// app/(dashboard)/properties/page.tsx
'use client';

import { useProperties } from '@/lib/api/properties';
import { PropertyCard } from '@/components/properties/property-card';

export default function PropertiesPage() {
    const { data: properties, isLoading, error } = useProperties(0, 15);

    if (isLoading) return <LoadingSpinner />;
    if (error) return <ErrorMessage error={error} />;

    return (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {properties.map(property => (
                <PropertyCard key={property.id} property={property} />
            ))}
        </div>
    );
}
```

**Deliverables**:
- ✅ All pages migrated to React/Next.js
- ✅ Modern UI component library
- ✅ SEO optimization with SSR
- ✅ Mobile-responsive design

---

## Phase 4: Testing & Quality (Months 10-12)

**Goal**: Ensure production readiness with comprehensive testing

**Cost**: $100K | **Risk**: Low | **Business Impact**: High

### 4.1 Backend Testing Strategy

**Unit Tests** (80% coverage goal):
```csharp
// RentMe.Web.Api.Tests/Services/PropertyServiceTests.cs
public class PropertyServiceTests
{
    [Fact]
    public async Task GetProperty_ExistingId_ReturnsProperty()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: "TestDb")
            .Options;

        using var context = new ApplicationDbContext(options);
        context.Properties.Add(new Property { Id = 1, Address = "123 Main St" });
        await context.SaveChangesAsync();

        var service = new PropertyService(context, null, null);

        // Act
        var result = await service.GetPropertyAsync(1);

        // Assert
        Assert.NotNull(result);
        Assert.Equal("123 Main St", result.Address);
    }
}
```

**Integration Tests**:
```csharp
// RentMe.Web.Api.Tests/Integration/PropertiesControllerTests.cs
public class PropertiesControllerTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public PropertiesControllerTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task GetProperties_ReturnsSuccessStatusCode()
    {
        // Act
        var response = await _client.GetAsync("/api/Properties");

        // Assert
        response.EnsureSuccessStatusCode();
        var properties = await response.Content.ReadFromJsonAsync<List<PropertyModel>>();
        Assert.NotNull(properties);
    }
}
```

**Timeline**: 4 weeks

### 4.2 Frontend Testing Strategy

**Component Tests** (Vitest + Testing Library):
```typescript
// components/properties/property-card.test.tsx
import { render, screen } from '@testing-library/react';
import { PropertyCard } from './property-card';

describe('PropertyCard', () => {
    const mockProperty = {
        id: 1,
        address: '123 Main St',
        city: 'Austin',
        state: 'TX',
        rent: 1500,
        bedrooms: 2,
        bathrooms: 2
    };

    it('renders property details correctly', () => {
        render(<PropertyCard property={mockProperty} />);

        expect(screen.getByText('123 Main St')).toBeInTheDocument();
        expect(screen.getByText('$1,500/mo')).toBeInTheDocument();
        expect(screen.getByText('2 bed')).toBeInTheDocument();
        expect(screen.getByText('2 bath')).toBeInTheDocument();
    });
});
```

**End-to-End Tests** (Playwright):
```typescript
// e2e/properties.spec.ts
import { test, expect } from '@playwright/test';

test('user can search for properties', async ({ page }) => {
    await page.goto('/properties');

    // Search for properties in Austin
    await page.fill('[data-testid="search-input"]', 'Austin');
    await page.click('[data-testid="search-button"]');

    // Wait for results
    await page.waitForSelector('[data-testid="property-card"]');

    // Verify results contain Austin
    const cards = await page.$$('[data-testid="property-card"]');
    expect(cards.length).toBeGreaterThan(0);

    const firstCard = cards[0];
    const text = await firstCard.textContent();
    expect(text).toContain('Austin');
});
```

**Timeline**: 4 weeks

**Deliverables**:
- ✅ Backend test coverage 80%+
- ✅ Frontend test coverage 80%+
- ✅ E2E test suite
- ✅ Load test reports

**Success Metrics**:
- All tests passing
- Coverage targets met
- Load tests successful (500+ concurrent users)

---

## Phase 5: Deployment & Cutover (Month 12)

**Goal**: Deploy to production with zero downtime

**Cost**: Included in Phase 4 | **Risk**: Low | **Business Impact**: High

### 5.1 Infrastructure as Code (Terraform)

```hcl
# infrastructure/main.tf
resource "azurerm_app_service_plan" "main" {
    name                = "rentme-app-service-plan"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name

    sku {
        tier = "Standard"
        size = "S2"
    }
}

resource "azurerm_app_service" "api" {
    name                = "rentme-api"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    app_service_plan_id = azurerm_app_service_plan.main.id

    site_config {
        dotnet_framework_version = "v8.0"
        always_on                = true
    }

    app_settings = {
        "ASPNETCORE_ENVIRONMENT" = "Production"
        "ConnectionStrings__DefaultConnection" = azurerm_sql_database.main.connection_string
    }
}
```

**Timeline**: 2 weeks

### 5.2 Cutover Plan

**Blue-Green Deployment**:
1. Deploy new system to "Green" environment
2. Run both systems in parallel for 1 week
3. Gradually route traffic: 10% → 25% → 50% → 100%
4. Monitor metrics closely
5. Keep "Blue" (old) system ready for quick rollback
6. After 2 weeks stable, decommission "Blue"

**Rollback Criteria**:
- Error rate > 1%
- Response time > 2x baseline
- Critical feature broken
- Database issues

**Monitoring Checklist**:
- [ ] Application Insights monitoring
- [ ] Database performance metrics
- [ ] API response times
- [ ] Error rates and logs
- [ ] User feedback channels

**Timeline**: 2 weeks

**Deliverables**:
- ✅ Infrastructure as code
- ✅ Blue-green deployment
- ✅ Monitoring dashboards
- ✅ Rollback procedures

**Success Metrics**:
- Zero downtime during cutover
- Error rate <0.1%
- Performance improved 3-5x

---

## Timeline Summary

```
Month 1-3:  ✅ Foundation (Git, CI/CD, cleanup)
Month 4-8:  ⚙️  Backend (.NET 8, async, testing)
Month 6-12: 🎨 Frontend (React, Next.js, migration)
Month 10-12: ✅ Testing & deployment
Month 12+:  🚀 Production cutover & monitoring
```

**Total Estimated Effort**: 12-15 months with 3-5 engineers

**Phase Overlap**: Phases 2 and 3 run in parallel (Months 6-8)

### Resource Allocation

| Phase | Duration | Team Size | Cost |
|-------|----------|-----------|------|
| **Phase 1: Foundation** | 3 months | 2 engineers | $150K |
| **Phase 2: Backend** | 5 months | 2 .NET engineers | $300K |
| **Phase 3: Frontend** | 7 months | 2 React engineers | $400K |
| **Phase 4: Testing** | 3 months | 1 QA + 2 developers | $100K |
| **Phase 5: Deployment** | 1 month | Full team | $60K |
| | | **TOTAL** | **$1,010,000** |

**Additional Resources**:
- Technical Lead/Architect: 0.5 FTE (12 months) = $120K
- DevOps Engineer: 0.5 FTE (12 months) = $90K
- Project Manager: 0.25 FTE (12 months) = $45K

**Grand Total**: $1,265,000

### Risk Mitigation

**Technical Risks**:
- **Migration complexity**: Parallel systems, feature flags, gradual cutover
- **Data migration**: Extensive testing, validation, rollback procedures
- **Performance issues**: Load testing, monitoring, performance budgets
- **Integration failures**: Comprehensive integration tests, staging environment

**Business Risks**:
- **Feature freeze**: Minimize new features during migration (6 months)
- **User disruption**: Transparent communication, gradual rollout
- **Budget overruns**: 20% contingency budget ($253K)
- **Timeline delays**: Agile sprints, weekly progress reviews

### Success Metrics

**Technical Success**:
- ✅ Zero data loss during migration
- ✅ Zero downtime during cutover
- ✅ 3-5x performance improvement
- ✅ 80%+ test coverage
- ✅ All systems on modern stack

**Business Success**:
- ✅ User satisfaction maintained (NPS ≥50)
- ✅ No critical incidents during migration
- ✅ On-time delivery (±2 weeks)
- ✅ On-budget delivery (±10%)
- ✅ Team morale improved

**Post-Launch Metrics** (3 months):
- Page load time <1 second
- API response time <100ms
- Error rate <0.1%
- Uptime 99.9%+
- Developer productivity +30%

---

**Document Version**: 1.0
**Last Updated**: October 4, 2025
**Maintained By**: Engineering Team
