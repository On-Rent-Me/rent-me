# System Design

**Audience**: Technical architects, senior engineers, and developers
**Last Updated**: October 4, 2025

---

## Table of Contents

1. [Architecture Deep Dive](#architecture-deep-dive)
2. [Project Dependency Graph](#project-dependency-graph)
3. [Best Practices Analysis](#best-practices-analysis)

---

## Architecture Deep Dive

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

### Layer Responsibilities

#### Presentation Layer
**Purpose**: Handle HTTP requests/responses and user interface

**Components**:
- **ASP.NET Web API (RentMe)**: RESTful API endpoints
  - Controllers: Route HTTP requests to services
  - Model Binding: Parse request data into C# objects
  - Authentication: JWT/Bearer token validation
  - Response Formatting: Serialize objects to JSON

- **AngularJS SPA (RentMe.Web.SPA)**: Single Page Application
  - Components: Reusable UI widgets
  - Services: HTTP client wrappers for API calls
  - Views: HTML templates with data binding
  - Routing: Client-side navigation

#### Business Logic Layer
**Purpose**: Implement domain logic and business rules

**Components**:
- **Services**: Core business operations
  - PropertyService: Property CRUD, search, validation
  - BillingService: Billing generation, calculations
  - AccountService: User registration, authentication
  - LeaseService: Lease management, renewals

- **Managers**: Cross-cutting concerns
  - AccessManager: Authorization checks
  - PhotoManager: Image upload/processing
  - EmailManager: Email notifications
  - SmsManager: Text messaging

**Key Principles**:
- Services contain NO HTTP/UI logic
- Services are unit-testable in isolation
- Business rules enforced at this layer
- Transactions managed at service level

#### Data Access Layer
**Purpose**: Interact with database and manage entities

**Components**:
- **ApplicationDbContext**: Entity Framework DbContext
  - Defines DbSet<T> for each table
  - Configures entity relationships
  - Manages database connections

- **Entities**: Database models (POCOs - Plain Old CLR Objects)
  - Property, User, Billing, Lease, etc.
  - Navigation properties for relationships
  - Data annotations for validation

- **Migrations**: Database schema changes
  - 318 migration files tracking schema evolution
  - Code-first approach (entities define schema)

**Key Principles**:
- Entities are isolated from business logic
- DbContext injected via dependency injection
- Lazy loading disabled (explicit `.Include()`)
- Migrations tracked in source control

#### Database Layer
**Purpose**: Persistent data storage

**Schema**:
- 50+ tables
- Foreign key constraints
- Indexes for performance
- Stored procedures (minimal usage)

---

## Project Dependency Graph

### Dependency Flow

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

### Dependency Principles

**Key Principle**: Dependencies flow **downward and inward**

1. **Presentation depends on Business Logic**
   - Web API depends on Services
   - Services do NOT depend on Controllers

2. **Business Logic depends on Data Access**
   - Services depend on DbContext and Entities
   - Entities do NOT depend on Services

3. **Integrations are Isolated**
   - Third-party integrations are separate projects
   - Can be swapped without affecting core business logic
   - All integrations depend on RentMe.Common (shared contracts)

4. **Common Libraries Have No Dependencies**
   - RentMe.Common has zero dependencies on higher layers
   - Pure utility functions and shared models
   - Can be reused across projects

### Project Organization Strategy

**By Technical Layer**:
```
✅ GOOD (Current Structure)
├── RentMe (API - Presentation)
├── RentMe.Data (Data Access)
├── RentMe.Web.Models (DTOs)
└── RentMe.Common (Shared)

❌ BAD (Avoid)
├── RentMe.Properties (All property code)
├── RentMe.Billing (All billing code)
└── RentMe.Users (All user code)
```

**Why Layered is Better**:
- Clear separation of concerns
- Easier to test individual layers
- Technology changes isolated to specific layers
- Common pattern across .NET ecosystem

---

## Best Practices Analysis

### ✅ What's Done Well

#### 1. **Separation of Concerns** (⭐⭐⭐⭐⭐ Excellent)

**Evidence**:
```
✓ Controllers handle HTTP routing only
✓ Services contain business logic
✓ Data access isolated in RentMe.Data
✓ DTOs separate from entities
✓ Integrations in separate projects
```

**Example**: PropertiesController.cs
```csharp
[HttpGet]
public IHttpActionResult GetPagedActiveProperties(int page = 0, int take = 15)
{
    try
    {
        // Controller does NOT contain business logic
        // Delegates to service layer
        var properties = _propertyService.GetActiveProperties(query, filter, take, page);
        return Ok(properties);  // Just returns result
    }
    catch (Exception ex)
    {
        _log.Error("Error getting properties", ex);
        return InternalServerError();
    }
}
```

**Why This Is Good**:
- Easy to test (mock services)
- Controllers can be changed without affecting logic
- Business rules in one place

#### 2. **Dependency Injection** (⭐⭐⭐⭐⭐ Excellent)

**Evidence**:
```csharp
// App_Start/AutofacConfiguration.cs
builder.RegisterAssemblyTypes(assembly)
    .Where(t => t.Name.EndsWith("Service"))
    .AsImplementedInterfaces()
    .InstancePerRequest();  // New instance per HTTP request
```

**Benefits**:
- No `new` keyword in controllers (testable)
- Easy to swap implementations
- Consistent lifecycle management

**Example Usage**:
```csharp
public class PropertiesController : ApiController
{
    private readonly IPropertyService _propertyService;
    private readonly IAccessManager _accessManager;

    // Dependencies injected by Autofac
    public PropertiesController(
        IPropertyService propertyService,
        IAccessManager accessManager)
    {
        _propertyService = propertyService;
        _accessManager = accessManager;
    }
}
```

#### 3. **Configuration Management** (⭐⭐⭐⭐ Good)

**Evidence**:
```
✓ Web.config for base settings
✓ Web.Debug.config for local development
✓ Web.Release.config for production
✓ Azure App Settings for secrets
```

**Example**: Web.Release.config transforms
```xml
<!-- Replaces dev connection string with production -->
<connectionStrings xdt:Transform="Replace">
    <add name="AzurePhotoStorage"
         connectionString="DefaultEndpointsProtocol=https;AccountName=rentmeimages;..." />
</connectionStrings>
```

**Why This Is Good**:
- Environment-specific settings
- Secrets not in source control
- Easy deployment across environments

#### 4. **Logging Strategy** (⭐⭐⭐⭐ Good)

**Evidence**:
```csharp
private readonly ILogger _log = LogFactory.GetInstance();

_log.Information($"Creating property for user {userId}");
_log.Warning($"Property not found: {propertyId}");
_log.Error($"Failed to process billing", ex);
```

**Benefits**:
- Abstraction allows swapping providers
- Consistent logging format
- Integration with Application Insights
- Structured logging with context

#### 5. **Project Organization** (⭐⭐⭐⭐ Good)

**Evidence**:
- 38 well-defined projects
- Clear naming conventions (RentMe.Web.*, RentMe.*.Tests)
- Integration projects isolated
- Test projects mirror main projects

**Structure Benefits**:
- Easy to locate functionality
- Clear project responsibilities
- Reusable components across solutions
- Build optimization (incremental builds)

### ⚠️ What Needs Improvement

#### 1. **Async/Await Not Used** (⭐⭐ Poor)

**Problem**: Most methods are synchronous, blocking threads

**Current Code**:
```csharp
// BAD: Synchronous (blocks thread)
public IHttpActionResult GetProperties()
{
    var properties = _propertyService.GetAll();  // Blocks while DB query runs
    return Ok(properties);
}
```

**Better Approach**:
```csharp
// GOOD: Asynchronous (frees thread while waiting)
public async Task<IHttpActionResult> GetProperties()
{
    var properties = await _propertyService.GetAllAsync();  // Thread free while waiting
    return Ok(properties);
}
```

**Impact**:
- **Performance**: Under load, blocked threads = fewer concurrent requests
- **Scalability**: More servers needed to handle same traffic
- **Cost**: Higher Azure hosting costs

**Fix**: Migrate all database and HTTP calls to async/await

#### 2. **LINQ N+1 Query Problems** (⭐⭐ Poor)

**Problem**: Multiple database queries in loops (performance killer)

**Bad Example**:
```csharp
// BAD: N+1 queries
var properties = _context.Properties.ToList();  // 1 query

foreach (var property in properties)
{
    var owner = _context.Users.Find(property.UserId);  // N queries! (one per property)
    property.OwnerName = owner.Name;
}
// Total: 1 + N queries instead of 1 query
```

**Better Approach**:
```csharp
// GOOD: Single query with JOIN
var properties = _context.Properties
    .Include(p => p.User)  // Eager load (SQL JOIN)
    .ToList();  // 1 query total

foreach (var property in properties)
{
    property.OwnerName = property.User.Name;  // Already loaded, no extra query
}
```

**Impact**:
- **Performance**: Slow page loads (1 query vs 100+ queries)
- **Database Load**: Connection pool exhaustion
- **User Experience**: Frustrating wait times

**Fix**: Use `.Include()` for related data, `.AsNoTracking()` for read-only queries

#### 3. **Limited Test Coverage** (⭐⭐ Poor)

**Problem**: Test projects exist but coverage appears incomplete

**Evidence**:
```
RentMe.Web.Api.Tests/        ✅ Exists
RentMe.Common.Tests/         ✅ Exists
RentMe.Utilities.Tests/      ✅ Exists

BUT: Number of test files appears low relative to source files
```

**Example of Good Test** (what's needed more of):
```csharp
[Fact]
public void CreateProperty_ValidInput_ReturnsProperty()
{
    // Arrange
    var mockService = new Mock<IPropertyService>();
    mockService.Setup(s => s.CreateProperty(It.IsAny<Property>()))
               .Returns(new Property { Id = 1 });
    var controller = new PropertiesController(mockService.Object, ...);

    // Act
    var result = controller.CreateProperty(new CreatePropertyModel { ... });

    // Assert
    Assert.IsType<OkObjectResult>(result);
    mockService.Verify(s => s.CreateProperty(It.IsAny<Property>()), Times.Once);
}
```

**Impact**:
- **Risk**: High likelihood of bugs in production
- **Refactoring**: Difficult to refactor safely
- **Confidence**: Low confidence in code changes

**Fix**: Aim for 80%+ code coverage

#### 4. **Error Handling Inconsistency** (⭐⭐⭐ Moderate)

**Problem**: Some controllers return generic errors

**Bad Example**:
```csharp
catch (Exception ex)
{
    _log.Error("Error occurred", ex);
    return InternalServerError();  // Generic 500, no details
}
```

**Better Approach**:
```csharp
// Global exception filter
public class GlobalExceptionFilter : ExceptionFilterAttribute
{
    public override void OnException(HttpActionExecutedContext context)
    {
        var exception = context.Exception;

        var response = new ErrorResponse
        {
            Message = GetUserFriendlyMessage(exception),
            ErrorCode = GetErrorCode(exception),
            TraceId = Activity.Current?.Id
        };

        context.Response = new HttpResponseMessage
        {
            StatusCode = GetStatusCode(exception),
            Content = new StringContent(JsonConvert.SerializeObject(response))
        };
    }
}
```

**Impact**:
- **Debugging**: Difficult to troubleshoot production issues
- **User Experience**: Unclear error messages
- **API Clients**: Cannot handle errors programmatically

**Fix**: Implement global exception handler with structured error responses

### Comparison to Industry Standards (2025)

| Aspect | RentMe (Current) | Industry Standard | Gap |
|--------|------------------|-------------------|-----|
| **Architecture Pattern** | N-tier (layered) | N-tier or Clean Architecture | ✅ **Good** |
| **Dependency Injection** | Autofac (IoC container) | Built-in DI or Autofac | ✅ **Excellent** |
| **ORM** | Entity Framework 6 | EF Core 8 | 🟠 **2 versions behind** |
| **Async Programming** | Minimal async/await | Async/await throughout | 🔴 **Poor** |
| **Test Coverage** | ~30% estimated | 80%+ | 🟠 **50% gap** |
| **API Documentation** | Minimal | Swagger/OpenAPI | 🔴 **Missing** |
| **Error Handling** | Inconsistent | Global middleware | 🟡 **Moderate** |
| **Logging** | Custom + App Insights | Serilog + structured logging | 🟡 **Moderate** |
| **Configuration** | Web.config transforms | appsettings.json + env vars | 🟠 **Legacy approach** |

### Architecture Evolution Recommendations

**Short Term (3-6 months)**:
1. Add comprehensive unit and integration tests
2. Implement async/await in critical paths
3. Fix N+1 query problems
4. Add global exception handling

**Medium Term (6-12 months)**:
1. Upgrade to .NET 8 and EF Core 8
2. Add Swagger/OpenAPI documentation
3. Implement structured logging (Serilog)
4. Add health checks and monitoring

**Long Term (12-18 months)**:
1. Consider Clean Architecture refactoring
2. Implement CQRS for complex domains
3. Add event-driven architecture for integrations
4. Implement API versioning strategy

---

**Document Version**: 1.0
**Last Updated**: October 4, 2025
**Maintained By**: Engineering Team
