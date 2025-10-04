# RentMe Code Examples and Patterns

**Last Updated**: October 4, 2025

This document provides comprehensive code examples for common patterns used throughout the RentMe codebase, including comparisons with modern equivalents.

---

## Table of Contents

1. [API Controller Pattern](#api-controller-pattern)
2. [Service Layer Pattern](#service-layer-pattern)
3. [Entity Framework Entity Pattern](#entity-framework-entity-pattern)
4. [AngularJS Component Pattern](#angularjs-component-pattern)
5. [AngularJS Service Pattern](#angularjs-service-pattern)
6. [Modern Framework Comparisons](#modern-framework-comparisons)

---

## API Controller Pattern

Controllers handle HTTP routing and delegate to services for business logic.

### Complete Controller Example

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

### Modern .NET 8 Equivalent

```csharp
// Minimal API approach
app.MapGet("/api/properties", async (
    [FromServices] IPropertyService service,
    [FromQuery] int page = 0,
    [FromQuery] int take = 15,
    [FromQuery] string? query = null) =>
{
    var properties = await service.GetActivePropertiesAsync(query, page, take);
    return Results.Ok(properties);
});

app.MapGet("/api/properties/{id}", async (
    int id,
    [FromServices] IPropertyService service) =>
{
    var property = await service.GetPropertyAsync(id);
    return property is not null ? Results.Ok(property) : Results.NotFound();
})
.WithName("GetPropertyById");

app.MapPost("/api/properties", async (
    [FromBody] CreatePropertyModel model,
    [FromServices] IPropertyService service,
    HttpContext context) =>
{
    var userId = context.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
    var property = await service.CreatePropertyAsync(model, userId!);
    return Results.CreatedAtRoute("GetPropertyById", new { id = property.Id }, property);
})
.RequireAuthorization("Landlord");
```

---

## Service Layer Pattern

Services contain business logic and database operations.

### Complete Service Example

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

### Modern .NET 8 with Async/Await

```csharp
public class PropertyService : IPropertyService
{
    private readonly ApplicationDbContext _context;
    private readonly IPhotoManager _photoManager;
    private readonly IMapper _mapper;

    public PropertyService(
        ApplicationDbContext context,
        IPhotoManager photoManager,
        IMapper mapper)
    {
        _context = context;
        _photoManager = photoManager;
        _mapper = mapper;
    }

    // Modern async version
    public async Task<Property?> GetPropertyAsync(int id)
    {
        return await _context.Properties
            .Include(p => p.User)
            .Include(p => p.Photos)
            .AsNoTracking()  // Read-only optimization
            .SingleOrDefaultAsync(p => p.Id == id);
    }

    public async Task<List<PropertyModel>> GetActivePropertiesAsync(
        string? query,
        int page,
        int take)
    {
        var properties = _context.Properties
            .Where(p => p.IsActive && !p.IsDeleted)
            .AsQueryable();

        if (!string.IsNullOrEmpty(query))
        {
            properties = properties.Where(p =>
                p.Address.Contains(query) ||
                p.City.Contains(query) ||
                p.Zip.Contains(query));
        }

        var results = await properties
            .OrderByDescending(p => p.DateCreated)
            .Skip(page * take)
            .Take(take)
            .AsNoTracking()
            .ToListAsync();

        return _mapper.Map<List<PropertyModel>>(results);
    }

    public async Task<Property> CreatePropertyAsync(CreatePropertyModel model, string userId)
    {
        ArgumentNullException.ThrowIfNull(model);
        ArgumentException.ThrowIfNullOrEmpty(userId);

        if (model.Rent <= 0)
            throw new ValidationException("Rent must be greater than zero");

        var property = _mapper.Map<Property>(model);
        property.UserId = userId;
        property.DateCreated = DateTime.UtcNow;
        property.IsActive = true;

        _context.Properties.Add(property);
        await _context.SaveChangesAsync();

        if (model.Photos?.Any() == true)
        {
            await _photoManager.UploadPropertyPhotosAsync(property.Id, model.Photos);
        }

        return property;
    }
}
```

---

## Entity Framework Entity Pattern

Entities represent database tables using C# classes.

### Complete Entity Example

**File**: `Production/RentMe.Data/Entities/Property.cs`

```csharp
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RentMe.Data.Entities
{
    [Table("Properties")]  // Maps to "Properties" table in SQL
    public class Property
    {
        // 1️⃣ PRIMARY KEY
        [Key]  // Marks as primary key
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]  // Auto-increment
        public int Id { get; set; }

        // 2️⃣ FOREIGN KEY (Many-to-One)
        [Required]
        public string UserId { get; set; }  // Foreign key to AspNetUsers table

        [ForeignKey("UserId")]  // Navigation property
        public virtual ApplicationUser User { get; set; }  // Allows: property.User.Name

        // 3️⃣ REQUIRED FIELDS
        [Required]
        [StringLength(200)]
        public string Address { get; set; }

        [Required]
        [StringLength(100)]
        public string City { get; set; }

        [Required]
        [StringLength(2)]
        public string State { get; set; }

        [Required]
        [StringLength(10)]
        public string Zip { get; set; }

        // 4️⃣ NUMERIC FIELDS
        [Required]
        [Column(TypeName = "decimal(18,2)")]  // SQL type
        public decimal Rent { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal? Deposit { get; set; }  // Nullable (? = can be NULL)

        public int Bedrooms { get; set; }
        public decimal Bathrooms { get; set; }  // Can be 1.5, 2.5, etc.

        public int? SquareFeet { get; set; }

        // 5️⃣ BOOLEAN FLAGS
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public bool IsFeatured { get; set; }
        public bool AllowPets { get; set; }

        // 6️⃣ DATES
        [Required]
        public DateTime DateCreated { get; set; }

        public DateTime? DateModified { get; set; }
        public DateTime? DateDeleted { get; set; }
        public DateTime? AvailableDate { get; set; }

        // 7️⃣ TEXT FIELDS
        [StringLength(5000)]
        public string Description { get; set; }

        [StringLength(1000)]
        public string Amenities { get; set; }

        // 8️⃣ NAVIGATION PROPERTIES (One-to-Many)
        public virtual ICollection<PropertyPhoto> Photos { get; set; }  // property.Photos
        public virtual ICollection<LeasePeriod> LeasePeriods { get; set; }  // property.LeasePeriods
        public virtual ICollection<Bid> Bids { get; set; }

        // 9️⃣ COMPUTED/NOT MAPPED PROPERTIES
        [NotMapped]  // Not stored in database
        public string FullAddress => $"{Address}, {City}, {State} {Zip}";

        [NotMapped]
        public string PrimaryPhotoUrl => Photos?.FirstOrDefault()?.Url;
    }
}
```

### LINQ Query Examples

```csharp
// 1️⃣ SIMPLE QUERY
var properties = _context.Properties
    .Where(p => p.IsActive)
    .ToList();

// 2️⃣ WITH EAGER LOADING (prevents N+1)
var properties = _context.Properties
    .Include(p => p.User)  // JOIN AspNetUsers
    .Include(p => p.Photos)  // JOIN PropertyPhotos
    .Where(p => p.IsActive)
    .ToList();

// 3️⃣ COMPLEX FILTERING
var properties = _context.Properties
    .Where(p => p.IsActive && !p.IsDeleted)
    .Where(p => p.Bedrooms >= 2 && p.Bathrooms >= 1.5m)
    .Where(p => p.Rent >= 1000 && p.Rent <= 2000)
    .Where(p => p.City == "Austin" && p.State == "TX")
    .OrderBy(p => p.Rent)
    .Skip(0)
    .Take(15)
    .ToList();

// 4️⃣ AGGREGATIONS
var avgRent = _context.Properties
    .Where(p => p.City == "Austin")
    .Average(p => p.Rent);

var propertyCount = _context.Properties
    .Where(p => p.IsActive)
    .Count();

// 5️⃣ GROUPING
var propertiesByCity = _context.Properties
    .GroupBy(p => p.City)
    .Select(g => new {
        City = g.Key,
        Count = g.Count(),
        AvgRent = g.Average(p => p.Rent)
    })
    .ToList();

// 6️⃣ JOINS
var propertiesWithOwners = _context.Properties
    .Join(_context.Users,
        p => p.UserId,
        u => u.Id,
        (p, u) => new {
            Property = p,
            OwnerName = u.Name,
            OwnerEmail = u.Email
        })
    .ToList();
```

---

## AngularJS Component Pattern

### Component Example

**File**: `Production/RentMe.Web.SPA/Components/LoadingSpinner/loadingSpinner.js`

```javascript
// 1️⃣ COMPONENT DEFINITION
angular.module('RentMeApp')
    .component('loadingSpinner', {
        // 2️⃣ TEMPLATE
        template: `
            <div ng-if="$ctrl.isLoading" class="loading-overlay">
                <div class="spinner">
                    <i class="fa fa-spinner fa-spin fa-3x"></i>
                    <p>{{ $ctrl.message }}</p>
                </div>
            </div>
        `,

        // 3️⃣ BINDINGS (props in React)
        bindings: {
            isLoading: '<',  // One-way binding (input)
            message: '@'     // String attribute
        },

        // 4️⃣ CONTROLLER (logic)
        controller: function() {
            var $ctrl = this;

            // Default values
            $ctrl.$onInit = function() {
                $ctrl.message = $ctrl.message || 'Loading...';
            };
        }
    });

// Usage in parent component:
// <loading-spinner is-loading="vm.loading" message="Fetching properties..."></loading-spinner>
```

---

## AngularJS Service Pattern

### Service Example

**File**: `Production/RentMe.Web.SPA/Services/PropertiesService.js`

```javascript
// 1️⃣ SERVICE DEFINITION
angular.module('RentMeApp')
    .factory('PropertiesService', ['$http', 'API_BASE_URL', function($http, API_BASE_URL) {

        // 2️⃣ SERVICE OBJECT
        var service = {
            getProperties: getProperties,
            getProperty: getProperty,
            createProperty: createProperty,
            updateProperty: updateProperty,
            deleteProperty: deleteProperty
        };

        return service;

        // 3️⃣ GET LIST
        function getProperties(page, take, query) {
            return $http({
                method: 'GET',
                url: API_BASE_URL + '/api/Properties',
                params: { page: page, take: take, query: query }
            })
            .then(function(response) {
                return response.data;  // Return just the data
            })
            .catch(function(error) {
                console.error('Error fetching properties:', error);
                throw error;
            });
        }

        // 4️⃣ GET SINGLE
        function getProperty(id) {
            return $http.get(API_BASE_URL + '/api/Properties/' + id)
                .then(function(response) {
                    return response.data;
                });
        }

        // 5️⃣ POST (CREATE)
        function createProperty(propertyData) {
            return $http.post(API_BASE_URL + '/api/Properties', propertyData)
                .then(function(response) {
                    return response.data;
                });
        }

        // 6️⃣ PUT (UPDATE)
        function updateProperty(id, propertyData) {
            return $http.put(API_BASE_URL + '/api/Properties/' + id, propertyData)
                .then(function(response) {
                    return response.data;
                });
        }

        // 7️⃣ DELETE
        function deleteProperty(id) {
            return $http.delete(API_BASE_URL + '/api/Properties/' + id);
        }
    }]);

// Usage in controller:
// PropertiesService.getProperties(0, 15, 'austin')
//     .then(function(properties) {
//         vm.properties = properties;
//     });
```

---

## Modern Framework Comparisons

### React Component (Modern Equivalent)

```jsx
// LoadingSpinner.jsx
function LoadingSpinner({ isLoading, message = 'Loading...' }) {
    if (!isLoading) return null;

    return (
        <div className="loading-overlay">
            <div className="spinner">
                <i className="fa fa-spinner fa-spin fa-3x" />
                <p>{message}</p>
            </div>
        </div>
    );
}

export default LoadingSpinner;

// Usage:
// <LoadingSpinner isLoading={loading} message="Fetching properties..." />
```

### React API Client with React Query

```typescript
// lib/api/properties.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL;

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
            const { data } = await axios.get<Property[]>(`${API_BASE_URL}/api/Properties`, {
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
            const { data } = await axios.get<Property>(`${API_BASE_URL}/api/Properties/${id}`);
            return data;
        }
    });
}

// POST (create)
export function useCreateProperty() {
    const queryClient = useQueryClient();

    return useMutation({
        mutationFn: async (property: Omit<Property, 'id'>) => {
            const { data } = await axios.post<Property>(`${API_BASE_URL}/api/Properties`, property);
            return data;
        },
        onSuccess: () => {
            // Invalidate cache
            queryClient.invalidateQueries({ queryKey: ['properties'] });
        }
    });
}

// Usage in component:
// const { data: properties, isLoading, error } = useProperties(0, 15, 'austin');
// const createMutation = useCreateProperty();
```

### TypeScript Type Safety

```typescript
// types/property.ts
export interface Property {
    id: number;
    address: string;
    city: string;
    state: string;
    zip: string;
    rent: number;
    deposit?: number;
    bedrooms: number;
    bathrooms: number;
    squareFeet?: number;
    isActive: boolean;
    isFeatured: boolean;
    allowPets: boolean;
    description?: string;
    amenities?: string;
    dateCreated: string;
    dateModified?: string;
    availableDate?: string;
}

export interface CreatePropertyModel {
    address: string;
    city: string;
    state: string;
    zip: string;
    rent: number;
    deposit?: number;
    bedrooms: number;
    bathrooms: number;
    squareFeet?: number;
    allowPets: boolean;
    description?: string;
    amenities?: string;
    availableDate?: string;
}

export interface PropertyFilters {
    query?: string;
    city?: string;
    state?: string;
    minRent?: number;
    maxRent?: number;
    bedrooms?: number;
    bathrooms?: number;
    allowPets?: boolean;
}
```

---

## Document Information

**Document Version**: 1.0
**Last Updated**: October 4, 2025
**Related Documents**:
- [System Overview](../01-overview/system-overview.md)
- [API Services](../04-backend/api-services.md)
- [Entity Framework Guide](../05-data/entity-framework.md)
- [Testing Guide](./testing.md)
