# RentMe API Services Reference

**Last Updated**: October 4, 2025

## Overview

This document provides a comprehensive reference for RentMe's backend API services, including project structure, service patterns, dependency injection configuration, and background jobs.

---

## Backend Project Structure

### Main Web API Project

```
📂 Production/RentMe/                    ⭐ MAIN WEB API PROJECT
│
├── 🎯 Controllers/                      WHERE: API endpoints defined
│   ├── PropertiesController.cs          Route: /api/Properties
│   ├── BillingController.cs             Route: /api/Billing
│   ├── AccountController.cs             Route: /api/Account
│   ├── LeaseController.cs               Route: /api/Lease
│   └── (24 more controllers)
│   ⚙️  WHAT: HTTP routing, request/response handling
│   📝 PATTERN: [HttpGet], [HttpPost], [Authorize] attributes
│
├── 🔧 Services/                         WHERE: Business logic
│   ├── PropertyService.cs               Property CRUD, search, validation
│   ├── BillingService.cs                Billing generation, calculations
│   ├── RentPayments/                    Payment processing services
│   ├── SmartMove/                       Credit check integration
│   ├── ShareAble/                       Credit reporting integration
│   └── (60+ service files)
│   ⚙️  WHAT: Core business rules, validation, workflows
│   📝 PATTERN: Interface + Implementation (IPropertyService, PropertyService)
│
├── 👔 Managers/                         WHERE: Cross-cutting concerns
│   ├── AccessManager.cs                 Authorization checks
│   ├── PhotoManager.cs                  Image upload/processing
│   └── (additional managers)
│   ⚙️  WHAT: Shared utilities used across services
│
├── 📋 ModelBinders/                     WHERE: Custom request parsing
│   └── PropertyFilterModelBinder.cs     Parse complex query parameters
│
├── 🔐 Providers/                        WHERE: OAuth/Authentication
│   └── SimpleAuthorizationServerProvider.cs
│
├── ⏰ ScheduledTasks/                   WHERE: Background jobs (Hangfire)
│   ├── CreateBillingsScheduledTask.cs   Daily billing generation
│   ├── AddLateFeesScheduledTask.cs      Late fee assessment
│   └── (15 more tasks)
│   ⚙️  WHAT: Cron jobs, recurring tasks
│
├── 🔌 HttpServices/                     WHERE: External API clients
│   ├── SmartMoveHttpService.cs          TransUnion API calls
│   ├── TelnyxSmsHttpService.cs          SMS API calls
│   └── (more HTTP clients)
│
├── 🚀 App_Start/                        WHERE: Startup configuration
│   ├── AutofacConfiguration.cs          Dependency injection setup
│   ├── AutoMapperConfiguration.cs       Object mapping profiles
│   ├── HangfireSchedulerConfiguration.cs Background job config
│   └── Startup.cs / Startup.Auth.cs     OAuth setup
│   ⚙️  WHAT: Application initialization (like main.ts in NestJS)
│
├── 📸 Photo/                            WHERE: Image management
│   ├── AzurePhotoManager.cs             Azure Blob Storage integration
│   └── AzureDocumentManager.cs          Document storage
│
└── 🛠️  Utilities/                       WHERE: Helper functions
    └── (various utility classes)
```

---

## API Controller Pattern

Controllers in RentMe handle HTTP routing and delegate business logic to services.

### Example: PropertiesController

**File**: `Production/RentMe/Controllers/PropertiesController.cs`

```csharp
using System.Web.Http;
using RentMe.Web.Api.Services;
using RentMe.Web.Models;

namespace RentMe.Web.Api.Controllers
{
    [Authorize]  // Require authentication
    [RoutePrefix("api/Properties")]  // Base route
    public class PropertiesController : ApiController
    {
        // 1️⃣ DEPENDENCY INJECTION
        private readonly IPropertyService _propertyService;
        private readonly IMapper _mapper;
        private readonly IAccessManager _accessManager;

        public PropertiesController(
            IPropertyService propertyService,  // Injected by Autofac
            IMapper mapper,
            IAccessManager accessManager)
        {
            _propertyService = propertyService;
            _mapper = mapper;
            _accessManager = accessManager;
        }

        // 2️⃣ GET ENDPOINT
        [AllowAnonymous]  // Override [Authorize], allow public access
        [Route("")]  // GET /api/Properties
        [HttpGet]
        public IHttpActionResult GetPagedActiveProperties(
            int page = 0,
            int take = 15,
            string query = null)
        {
            // Delegate to service layer
            var properties = _propertyService.GetActiveProperties(query, filter, take, page);
            return Ok(properties);  // Returns 200 OK with JSON
        }

        // 3️⃣ GET BY ID ENDPOINT
        [AllowAnonymous]
        [Route("{id:int}")]  // GET /api/Properties/123
        [HttpGet]
        public IHttpActionResult GetPropertyById(int id)
        {
            var property = _propertyService.GetProperty(id);

            if (property == null)
                return NotFound();  // 404 Not Found

            return Ok(property);  // 200 OK
        }

        // 4️⃣ POST ENDPOINT
        [Authorize(Roles = "Landlord")]  // Only landlords can create
        [Route("")]  // POST /api/Properties
        [HttpPost]
        public IHttpActionResult CreateProperty(CreatePropertyModel model)
        {
            // Model binding + validation happens automatically
            if (!ModelState.IsValid)
                return BadRequest(ModelState);  // 400 Bad Request

            var userId = User.Identity.GetUserId();  // Get current user

            // Authorization check
            if (!_accessManager.CanUserCreateProperty(userId))
                return Unauthorized();  // 401 Unauthorized

            var property = _propertyService.CreateProperty(model, userId);

            return CreatedAtRoute(
                "GetPropertyById",  // Route name
                new { id = property.Id },  // Route values
                property  // Response body
            );  // 201 Created with Location header
        }

        // 5️⃣ PUT ENDPOINT
        [Authorize]
        [Route("{id:int}")]  // PUT /api/Properties/123
        [HttpPut]
        public IHttpActionResult UpdateProperty(int id, UpdatePropertyModel model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // Authorization check
            if (!_accessManager.CanCurrentUserManageProperty(id))
                return Forbid();  // 403 Forbidden

            _propertyService.UpdateProperty(id, model);

            return Ok();  // 200 OK
        }

        // 6️⃣ DELETE ENDPOINT
        [Authorize]
        [Route("{id:int}")]  // DELETE /api/Properties/123
        [HttpDelete]
        public IHttpActionResult DeleteProperty(int id)
        {
            if (!_accessManager.CanCurrentUserManageProperty(id))
                return Forbid();

            _propertyService.DeleteProperty(id);

            return NoContent();  // 204 No Content
        }
    }
}
```

### Key Controller Concepts

- `[RoutePrefix]`: Base URL for all actions
- `[Route]`: Specific route pattern
- `[HttpGet]`, `[HttpPost]`, `[HttpPut]`, `[HttpDelete]`: HTTP verb
- `[Authorize]`: Requires authentication
- `[Authorize(Roles = "...")]`: Requires specific role
- `[AllowAnonymous]`: Override authorization requirement
- `IHttpActionResult`: Return type (similar to ActionResult in ASP.NET Core)
- Dependency injection via constructor

---

## Service Layer Pattern

Services contain the core business logic and are injected into controllers.

### Example: PropertyService

**File**: `Production/RentMe/Services/PropertyService.cs`

```csharp
using System.Linq;
using RentMe.Data;
using RentMe.Data.Entities;
using RentMe.Web.Models;

namespace RentMe.Web.Api.Services
{
    // 1️⃣ INTERFACE (for DI and testing)
    public interface IPropertyService
    {
        Property GetProperty(int id);
        List<PropertyModel> GetActiveProperties(string query, string filter, int take, int page);
        Property CreateProperty(CreatePropertyModel model, string userId);
        void UpdateProperty(int id, UpdatePropertyModel model);
        void DeleteProperty(int id);
    }

    // 2️⃣ IMPLEMENTATION
    public class PropertyService : IPropertyService
    {
        private readonly ApplicationDbContext _context;
        private readonly IPhotoManager _photoManager;
        private readonly IMapper _mapper;

        public PropertyService(
            ApplicationDbContext context,  // EF DbContext
            IPhotoManager photoManager,
            IMapper mapper)
        {
            _context = context;
            _photoManager = photoManager;
            _mapper = mapper;
        }

        // 3️⃣ RETRIEVE SINGLE ENTITY
        public Property GetProperty(int id)
        {
            return _context.Properties
                .Include(p => p.User)  // Eager load owner (SQL JOIN)
                .Include(p => p.Photos)  // Eager load photos
                .SingleOrDefault(p => p.Id == id);
        }

        // 4️⃣ RETRIEVE LIST WITH FILTERING
        public List<PropertyModel> GetActiveProperties(
            string query,
            string filter,
            int take,
            int page)
        {
            // Build query
            var properties = _context.Properties
                .Where(p => p.IsActive && !p.IsDeleted);  // Base filter

            // Apply search
            if (!string.IsNullOrEmpty(query))
            {
                properties = properties.Where(p =>
                    p.Address.Contains(query) ||
                    p.City.Contains(query) ||
                    p.Zip.Contains(query)
                );
            }

            // Apply filter
            if (filter == "featured")
                properties = properties.Where(p => p.IsFeatured);

            // Apply pagination
            var results = properties
                .OrderByDescending(p => p.DateCreated)
                .Skip(page * take)  // Offset
                .Take(take)  // Limit
                .ToList();  // Execute query

            // Map to DTOs
            return _mapper.Map<List<PropertyModel>>(results);
        }

        // 5️⃣ CREATE ENTITY
        public Property CreateProperty(CreatePropertyModel model, string userId)
        {
            // Validate business rules
            if (model.Rent <= 0)
                throw new ValidationException("Rent must be greater than zero");

            // Map DTO to entity
            var property = _mapper.Map<Property>(model);
            property.UserId = userId;
            property.DateCreated = DateTime.UtcNow;
            property.IsActive = true;

            // Save to database
            _context.Properties.Add(property);
            _context.SaveChanges();  // Generates SQL INSERT

            // Upload photos
            if (model.Photos != null && model.Photos.Any())
            {
                _photoManager.UploadPropertyPhotos(property.Id, model.Photos);
            }

            return property;
        }

        // 6️⃣ UPDATE ENTITY
        public void UpdateProperty(int id, UpdatePropertyModel model)
        {
            var property = _context.Properties.Find(id);

            if (property == null)
                throw new NotFoundException("Property not found");

            // Update fields
            _mapper.Map(model, property);  // Maps matching properties
            property.DateModified = DateTime.UtcNow;

            // Save changes
            _context.SaveChanges();  // Generates SQL UPDATE
        }

        // 7️⃣ DELETE ENTITY (soft delete)
        public void DeleteProperty(int id)
        {
            var property = _context.Properties.Find(id);

            if (property == null)
                throw new NotFoundException("Property not found");

            // Soft delete (don't actually remove from DB)
            property.IsDeleted = true;
            property.DateDeleted = DateTime.UtcNow;

            _context.SaveChanges();  // Generates SQL UPDATE
        }
    }
}
```

### Key Service Concepts

- **Interface + Implementation pattern** for dependency injection
- **DbContext** for database access via Entity Framework
- **LINQ** for queries (similar to SQL but in C#)
- `.Include()` for eager loading related entities (prevents N+1 queries)
- `.ToList()` executes the query (before this, it's just building SQL)
- **AutoMapper** for DTO ↔ Entity conversion
- **Soft deletes** (set `IsDeleted = true` instead of SQL DELETE)

---

## Dependency Injection Configuration

RentMe uses **Autofac** for dependency injection.

### Autofac Configuration

**File**: `Production/RentMe/App_Start/AutofacConfiguration.cs`

```csharp
using Autofac;
using Autofac.Integration.WebApi;
using System.Reflection;

namespace RentMe.Web.Api.App_Start
{
    public class AutofacConfiguration
    {
        public static void Configure(HttpConfiguration config)
        {
            var builder = new ContainerBuilder();

            // Register API controllers
            builder.RegisterApiControllers(Assembly.GetExecutingAssembly());

            // Register services (Interface → Implementation)
            builder.RegisterAssemblyTypes(Assembly.GetExecutingAssembly())
                .Where(t => t.Name.EndsWith("Service"))
                .AsImplementedInterfaces()
                .InstancePerRequest();  // New instance per HTTP request

            // Register managers
            builder.RegisterAssemblyTypes(Assembly.GetExecutingAssembly())
                .Where(t => t.Name.EndsWith("Manager"))
                .AsImplementedInterfaces()
                .InstancePerRequest();

            // Register DbContext
            builder.RegisterType<ApplicationDbContext>()
                .AsSelf()
                .InstancePerRequest();

            // Register AutoMapper
            builder.Register(c => AutoMapperConfiguration.Configure())
                .As<IMapper>()
                .SingleInstance();

            // Build container
            var container = builder.Build();
            config.DependencyResolver = new AutofacWebApiDependencyResolver(container);
        }
    }
}
```

### Lifetime Scopes

- **InstancePerRequest**: New instance for each HTTP request (most common)
- **SingleInstance**: One instance for entire application (like singletons)
- **InstancePerDependency**: New instance every time it's injected

---

## Background Jobs with Hangfire

RentMe uses **Hangfire** for scheduled background tasks.

### Background Job Examples

**File**: `Production/RentMe/ScheduledTasks/CreateBillingsScheduledTask.cs`

```csharp
using Hangfire;

namespace RentMe.Web.Api.ScheduledTasks
{
    public class CreateBillingsScheduledTask
    {
        private readonly IBillingService _billingService;

        public CreateBillingsScheduledTask(IBillingService billingService)
        {
            _billingService = billingService;
        }

        public void Execute()
        {
            _billingService.GenerateMonthlyBillings();
        }
    }
}
```

### Hangfire Configuration

**File**: `Production/RentMe/App_Start/HangfireSchedulerConfiguration.cs`

```csharp
using Hangfire;

public class HangfireSchedulerConfiguration
{
    public static void ConfigureScheduledTasks()
    {
        // Daily at 2:00 AM - Generate monthly billings
        RecurringJob.AddOrUpdate<CreateBillingsScheduledTask>(
            "create-monthly-billings",
            task => task.Execute(),
            Cron.Daily(2));

        // Daily at 3:00 AM - Add late fees
        RecurringJob.AddOrUpdate<AddLateFeesScheduledTask>(
            "add-late-fees",
            task => task.Execute(),
            Cron.Daily(3));

        // Every hour - Send pending emails
        RecurringJob.AddOrUpdate<SendPendingEmailsScheduledTask>(
            "send-pending-emails",
            task => task.Execute(),
            Cron.Hourly());

        // Weekly on Sundays at 4:00 AM - Cleanup old data
        RecurringJob.AddOrUpdate<CleanupOldDataScheduledTask>(
            "cleanup-old-data",
            task => task.Execute(),
            Cron.Weekly(DayOfWeek.Sunday, 4));
    }
}
```

### Common Scheduled Tasks

| Task | Schedule | Purpose |
|------|----------|---------|
| **CreateBillingsScheduledTask** | Daily at 2:00 AM | Generate monthly rent billings |
| **AddLateFeesScheduledTask** | Daily at 3:00 AM | Apply late fees to overdue billings |
| **SendPendingEmailsScheduledTask** | Hourly | Send queued email notifications |
| **ProcessRentPaymentsScheduledTask** | Daily at 1:00 AM | Process ACH rent payments |
| **SyncZillowListingsScheduledTask** | Daily at 5:00 AM | Sync property listings to Zillow |
| **GenerateReportsScheduledTask** | Weekly on Mondays | Generate weekly analytics reports |
| **CleanupOldDataScheduledTask** | Weekly on Sundays | Archive/delete old records |

---

## API Endpoints Overview

### Properties API

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/Properties` | List active properties (paginated) |
| GET | `/api/Properties/{id}` | Get property details |
| POST | `/api/Properties` | Create new property |
| PUT | `/api/Properties/{id}` | Update property |
| DELETE | `/api/Properties/{id}` | Delete property (soft delete) |
| GET | `/api/Properties/{id}/photos` | Get property photos |
| POST | `/api/Properties/{id}/photos` | Upload property photo |

### Billing API

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/Billing` | List user billings |
| GET | `/api/Billing/{id}` | Get billing details |
| POST | `/api/Billing/{id}/pay` | Process payment |
| GET | `/api/Billing/outstanding` | Get outstanding balances |

### Account API

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/api/Account/Register` | Create new user account |
| POST | `/api/Account/Login` | User login (returns JWT) |
| GET | `/api/Account/UserInfo` | Get current user info |
| PUT | `/api/Account/ChangePassword` | Change password |
| POST | `/api/Account/ForgotPassword` | Send password reset email |

### Lease API

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/Lease` | List user leases |
| GET | `/api/Lease/{id}` | Get lease details |
| POST | `/api/Lease` | Create new lease |
| PUT | `/api/Lease/{id}` | Update lease |
| POST | `/api/Lease/{id}/sign` | Sign lease electronically |

---

## Document Information

**Document Version**: 1.0
**Last Updated**: October 4, 2025
**Related Documents**:
- [System Overview](../01-overview/system-overview.md)
- [Entity Framework Guide](../05-data/entity-framework.md)
- [Code Examples](../10-development/code-examples.md)
