# RentMe Testing Guide

**Last Updated**: October 4, 2025

This document covers testing strategies, patterns, and best practices for the RentMe application.

---

## Overview

RentMe uses a combination of testing approaches:

- **Unit Tests**: xUnit for backend, limited frontend tests
- **Integration Tests**: API endpoint testing
- **Test Coverage**: Estimated ~30% (industry standard: 80%+)

---

## Backend Testing (C# / xUnit)

### Unit Test Structure

RentMe uses **xUnit** as the primary testing framework with **Moq** for mocking dependencies.

### Test Project Structure

```
RentMe.Tests.Common/            🧪 Shared test utilities
RentMe.Common.Tests/            ✅ Unit tests for common lib
RentMe.Utilities.Tests/         ✅ Unit tests for utilities
RentMe.Web.Api.Tests/           ✅ API integration tests
RentMe.Web.SPA.Tests/           ✅ Frontend unit tests
RentMe.ProfitStarsIntegration.Tests/
RentMe.SureAppIntegration.Tests/
RentMe.ImageProcessing.Tests/
```

---

## Service Layer Unit Tests

### Example: PropertyService Tests

**File**: `RentMe.Web.Api.Tests/Services/PropertyServiceTests.cs`

```csharp
using Xunit;
using Moq;
using RentMe.Data;
using RentMe.Data.Entities;
using RentMe.Web.Api.Services;
using System.Linq;
using Microsoft.EntityFrameworkCore;

namespace RentMe.Web.Api.Tests.Services
{
    public class PropertyServiceTests
    {
        // 1️⃣ TEST: GET PROPERTY - EXISTING ID
        [Fact]
        public void GetProperty_ExistingId_ReturnsProperty()
        {
            // Arrange
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "TestDb_GetProperty")
                .Options;

            using var context = new ApplicationDbContext(options);
            var testProperty = new Property
            {
                Id = 1,
                Address = "123 Main St",
                City = "Austin",
                State = "TX",
                Zip = "78701",
                Rent = 1500,
                Bedrooms = 2,
                Bathrooms = 2,
                IsActive = true,
                UserId = "user123"
            };
            context.Properties.Add(testProperty);
            context.SaveChanges();

            var mockMapper = new Mock<IMapper>();
            var mockPhotoManager = new Mock<IPhotoManager>();
            var service = new PropertyService(context, mockPhotoManager.Object, mockMapper.Object);

            // Act
            var result = service.GetProperty(1);

            // Assert
            Assert.NotNull(result);
            Assert.Equal("123 Main St", result.Address);
            Assert.Equal("Austin", result.City);
            Assert.Equal(1500, result.Rent);
        }

        // 2️⃣ TEST: GET PROPERTY - NON-EXISTENT ID
        [Fact]
        public void GetProperty_NonExistentId_ReturnsNull()
        {
            // Arrange
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "TestDb_GetProperty_NotFound")
                .Options;

            using var context = new ApplicationDbContext(options);
            var mockMapper = new Mock<IMapper>();
            var mockPhotoManager = new Mock<IPhotoManager>();
            var service = new PropertyService(context, mockPhotoManager.Object, mockMapper.Object);

            // Act
            var result = service.GetProperty(999);

            // Assert
            Assert.Null(result);
        }

        // 3️⃣ TEST: CREATE PROPERTY - VALID DATA
        [Fact]
        public void CreateProperty_ValidData_ReturnsCreatedProperty()
        {
            // Arrange
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "TestDb_CreateProperty")
                .Options;

            using var context = new ApplicationDbContext(options);
            var mockMapper = new Mock<IMapper>();
            var mockPhotoManager = new Mock<IPhotoManager>();

            var model = new CreatePropertyModel
            {
                Address = "456 Oak Ave",
                City = "Dallas",
                State = "TX",
                Zip = "75201",
                Rent = 2000,
                Bedrooms = 3,
                Bathrooms = 2.5m
            };

            mockMapper.Setup(m => m.Map<Property>(It.IsAny<CreatePropertyModel>()))
                .Returns(new Property
                {
                    Address = model.Address,
                    City = model.City,
                    State = model.State,
                    Zip = model.Zip,
                    Rent = model.Rent,
                    Bedrooms = model.Bedrooms,
                    Bathrooms = model.Bathrooms
                });

            var service = new PropertyService(context, mockPhotoManager.Object, mockMapper.Object);

            // Act
            var result = service.CreateProperty(model, "user123");

            // Assert
            Assert.NotNull(result);
            Assert.True(result.Id > 0);
            Assert.Equal("456 Oak Ave", result.Address);
            Assert.Equal("user123", result.UserId);
            Assert.True(result.IsActive);
            Assert.NotNull(result.DateCreated);
        }

        // 4️⃣ TEST: CREATE PROPERTY - INVALID RENT
        [Fact]
        public void CreateProperty_InvalidRent_ThrowsValidationException()
        {
            // Arrange
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "TestDb_CreateProperty_Invalid")
                .Options;

            using var context = new ApplicationDbContext(options);
            var mockMapper = new Mock<IMapper>();
            var mockPhotoManager = new Mock<IPhotoManager>();

            var model = new CreatePropertyModel
            {
                Address = "789 Elm St",
                Rent = -100  // Invalid rent
            };

            var service = new PropertyService(context, mockPhotoManager.Object, mockMapper.Object);

            // Act & Assert
            Assert.Throws<ValidationException>(() =>
                service.CreateProperty(model, "user123"));
        }

        // 5️⃣ TEST: UPDATE PROPERTY - EXISTING PROPERTY
        [Fact]
        public void UpdateProperty_ExistingProperty_UpdatesSuccessfully()
        {
            // Arrange
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "TestDb_UpdateProperty")
                .Options;

            using var context = new ApplicationDbContext(options);
            var property = new Property
            {
                Id = 1,
                Address = "123 Main St",
                Rent = 1500,
                IsActive = true
            };
            context.Properties.Add(property);
            context.SaveChanges();

            var mockMapper = new Mock<IMapper>();
            var mockPhotoManager = new Mock<IPhotoManager>();

            var updateModel = new UpdatePropertyModel
            {
                Address = "123 Main Street",
                Rent = 1600
            };

            mockMapper.Setup(m => m.Map(It.IsAny<UpdatePropertyModel>(), It.IsAny<Property>()))
                .Callback<UpdatePropertyModel, Property>((model, prop) =>
                {
                    prop.Address = model.Address;
                    prop.Rent = model.Rent;
                });

            var service = new PropertyService(context, mockPhotoManager.Object, mockMapper.Object);

            // Act
            service.UpdateProperty(1, updateModel);

            // Assert
            var updated = context.Properties.Find(1);
            Assert.Equal("123 Main Street", updated.Address);
            Assert.Equal(1600, updated.Rent);
            Assert.NotNull(updated.DateModified);
        }

        // 6️⃣ TEST: DELETE PROPERTY - SOFT DELETE
        [Fact]
        public void DeleteProperty_ExistingProperty_SoftDeletesSuccessfully()
        {
            // Arrange
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "TestDb_DeleteProperty")
                .Options;

            using var context = new ApplicationDbContext(options);
            var property = new Property
            {
                Id = 1,
                Address = "123 Main St",
                IsActive = true,
                IsDeleted = false
            };
            context.Properties.Add(property);
            context.SaveChanges();

            var mockMapper = new Mock<IMapper>();
            var mockPhotoManager = new Mock<IPhotoManager>();
            var service = new PropertyService(context, mockPhotoManager.Object, mockMapper.Object);

            // Act
            service.DeleteProperty(1);

            // Assert
            var deleted = context.Properties.Find(1);
            Assert.True(deleted.IsDeleted);
            Assert.NotNull(deleted.DateDeleted);
        }

        // 7️⃣ TEST: GET ACTIVE PROPERTIES - WITH PAGINATION
        [Fact]
        public void GetActiveProperties_WithPagination_ReturnsCorrectPage()
        {
            // Arrange
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "TestDb_Pagination")
                .Options;

            using var context = new ApplicationDbContext(options);

            // Add 25 properties
            for (int i = 1; i <= 25; i++)
            {
                context.Properties.Add(new Property
                {
                    Id = i,
                    Address = $"{i} Main St",
                    City = "Austin",
                    Rent = 1000 + (i * 100),
                    IsActive = true,
                    IsDeleted = false,
                    DateCreated = DateTime.UtcNow.AddDays(-i)
                });
            }
            context.SaveChanges();

            var mockMapper = new Mock<IMapper>();
            mockMapper.Setup(m => m.Map<List<PropertyModel>>(It.IsAny<List<Property>>()))
                .Returns((List<Property> props) => props.Select(p => new PropertyModel
                {
                    Id = p.Id,
                    Address = p.Address,
                    Rent = p.Rent
                }).ToList());

            var mockPhotoManager = new Mock<IPhotoManager>();
            var service = new PropertyService(context, mockPhotoManager.Object, mockMapper.Object);

            // Act
            var page1 = service.GetActiveProperties(null, null, 10, 0);
            var page2 = service.GetActiveProperties(null, null, 10, 1);

            // Assert
            Assert.Equal(10, page1.Count);
            Assert.Equal(10, page2.Count);
            Assert.NotEqual(page1.First().Id, page2.First().Id);
        }

        // 8️⃣ TEST: GET ACTIVE PROPERTIES - WITH SEARCH
        [Fact]
        public void GetActiveProperties_WithSearchQuery_FiltersCorrectly()
        {
            // Arrange
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "TestDb_Search")
                .Options;

            using var context = new ApplicationDbContext(options);

            context.Properties.Add(new Property
            {
                Id = 1,
                Address = "123 Main St",
                City = "Austin",
                IsActive = true
            });
            context.Properties.Add(new Property
            {
                Id = 2,
                Address = "456 Oak Ave",
                City = "Dallas",
                IsActive = true
            });
            context.SaveChanges();

            var mockMapper = new Mock<IMapper>();
            mockMapper.Setup(m => m.Map<List<PropertyModel>>(It.IsAny<List<Property>>()))
                .Returns((List<Property> props) => props.Select(p => new PropertyModel
                {
                    Id = p.Id,
                    Address = p.Address,
                    City = p.City
                }).ToList());

            var mockPhotoManager = new Mock<IPhotoManager>();
            var service = new PropertyService(context, mockPhotoManager.Object, mockMapper.Object);

            // Act
            var results = service.GetActiveProperties("Austin", null, 10, 0);

            // Assert
            Assert.Single(results);
            Assert.Equal("Austin", results.First().City);
        }
    }
}
```

---

## Controller Integration Tests

### Example: PropertiesController Integration Tests

**File**: `RentMe.Web.Api.Tests/Integration/PropertiesControllerTests.cs`

```csharp
using Xunit;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Testing;

namespace RentMe.Web.Api.Tests.Integration
{
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
            Assert.Equal("application/json", response.Content.Headers.ContentType.MediaType);
        }

        [Fact]
        public async Task GetProperty_ExistingId_ReturnsProperty()
        {
            // Act
            var response = await _client.GetAsync("/api/Properties/1");

            // Assert
            response.EnsureSuccessStatusCode();
            var content = await response.Content.ReadAsStringAsync();
            Assert.Contains("address", content.ToLower());
        }

        [Fact]
        public async Task GetProperty_NonExistentId_Returns404()
        {
            // Act
            var response = await _client.GetAsync("/api/Properties/99999");

            // Assert
            Assert.Equal(System.Net.HttpStatusCode.NotFound, response.StatusCode);
        }

        [Fact]
        public async Task CreateProperty_WithoutAuth_Returns401()
        {
            // Arrange
            var content = new StringContent("{}", System.Text.Encoding.UTF8, "application/json");

            // Act
            var response = await _client.PostAsync("/api/Properties", content);

            // Assert
            Assert.Equal(System.Net.HttpStatusCode.Unauthorized, response.StatusCode);
        }
    }
}
```

---

## Modern Testing Patterns (.NET 8)

### Async Unit Tests

```csharp
public class PropertyServiceTests
{
    [Fact]
    public async Task GetPropertyAsync_ExistingId_ReturnsProperty()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        await using var context = new ApplicationDbContext(options);
        var testProperty = new Property
        {
            Id = 1,
            Address = "123 Main St",
            IsActive = true
        };
        context.Properties.Add(testProperty);
        await context.SaveChangesAsync();

        var mockMapper = new Mock<IMapper>();
        var mockPhotoManager = new Mock<IPhotoManager>();
        var service = new PropertyService(context, mockPhotoManager.Object, mockMapper.Object);

        // Act
        var result = await service.GetPropertyAsync(1);

        // Assert
        Assert.NotNull(result);
        Assert.Equal("123 Main St", result.Address);
    }
}
```

### Theory Tests (Data-Driven)

```csharp
public class PropertyValidationTests
{
    [Theory]
    [InlineData(0, false)]
    [InlineData(-100, false)]
    [InlineData(500, true)]
    [InlineData(5000, true)]
    public void ValidateRent_VariousValues_ReturnsExpectedResult(decimal rent, bool expected)
    {
        // Arrange
        var validator = new PropertyValidator();

        // Act
        var result = validator.IsValidRent(rent);

        // Assert
        Assert.Equal(expected, result);
    }

    [Theory]
    [MemberData(nameof(GetPropertyTestData))]
    public void ValidateProperty_VariousProperties_ReturnsExpectedResult(
        Property property,
        bool expected)
    {
        // Arrange
        var validator = new PropertyValidator();

        // Act
        var result = validator.IsValid(property);

        // Assert
        Assert.Equal(expected, result);
    }

    public static IEnumerable<object[]> GetPropertyTestData()
    {
        yield return new object[] { new Property { Rent = 1000, Bedrooms = 2 }, true };
        yield return new object[] { new Property { Rent = 0, Bedrooms = 2 }, false };
        yield return new object[] { new Property { Rent = 1000, Bedrooms = 0 }, false };
    }
}
```

---

## Frontend Testing (AngularJS)

### Limited Frontend Testing

The current RentMe frontend has limited test coverage. Here's an example of what exists:

**File**: `RentMe.Web.SPA.Tests/Components/loadingSpinner.spec.js`

```javascript
describe('LoadingSpinner Component', function() {
    var $componentController;
    var $scope;

    beforeEach(module('RentMeApp'));

    beforeEach(inject(function(_$componentController_, $rootScope) {
        $componentController = _$componentController_;
        $scope = $rootScope.$new();
    }));

    it('should initialize with default message', function() {
        var bindings = { isLoading: true };
        var ctrl = $componentController('loadingSpinner', { $scope: $scope }, bindings);

        ctrl.$onInit();

        expect(ctrl.message).toBe('Loading...');
    });

    it('should use custom message when provided', function() {
        var bindings = { isLoading: true, message: 'Custom loading...' };
        var ctrl = $componentController('loadingSpinner', { $scope: $scope }, bindings);

        ctrl.$onInit();

        expect(ctrl.message).toBe('Custom loading...');
    });
});
```

### Modern Frontend Testing (React + Vitest)

```typescript
// LoadingSpinner.test.tsx
import { render, screen } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import LoadingSpinner from './LoadingSpinner';

describe('LoadingSpinner', () => {
    it('renders when isLoading is true', () => {
        render(<LoadingSpinner isLoading={true} />);

        expect(screen.getByText('Loading...')).toBeInTheDocument();
    });

    it('does not render when isLoading is false', () => {
        render(<LoadingSpinner isLoading={false} />);

        expect(screen.queryByText('Loading...')).not.toBeInTheDocument();
    });

    it('displays custom message', () => {
        render(<LoadingSpinner isLoading={true} message="Fetching data..." />);

        expect(screen.getByText('Fetching data...')).toBeInTheDocument();
    });
});
```

---

## Test Coverage Recommendations

### Current State

**Estimated Coverage**: ~30%
- Services: ~40%
- Controllers: ~25%
- Utilities: ~50%
- Frontend: ~10%

### Industry Standard

**Target Coverage**: 80%+
- Critical paths: 100%
- Services: 90%+
- Controllers: 80%+
- Utilities: 90%+
- Frontend: 70%+

### Coverage Strategy

1. **High Priority** (Critical Business Logic):
   - Payment processing
   - Billing generation
   - Lease management
   - User authentication

2. **Medium Priority** (Core Features):
   - Property CRUD operations
   - Search and filtering
   - File uploads
   - Email notifications

3. **Low Priority** (Utilities):
   - Helper functions
   - Extensions
   - Formatters

---

## Test Best Practices

### Naming Convention

```csharp
// Pattern: MethodName_StateUnderTest_ExpectedBehavior
[Fact]
public void GetProperty_ExistingId_ReturnsProperty() { }

[Fact]
public void GetProperty_NonExistentId_ReturnsNull() { }

[Fact]
public void CreateProperty_ValidData_ReturnsCreatedProperty() { }

[Fact]
public void CreateProperty_InvalidRent_ThrowsValidationException() { }
```

### Arrange-Act-Assert Pattern

```csharp
[Fact]
public void Example_Test()
{
    // Arrange: Set up test data and dependencies
    var mockService = new Mock<IPropertyService>();
    var controller = new PropertiesController(mockService.Object);

    // Act: Execute the method being tested
    var result = controller.GetProperties();

    // Assert: Verify the expected outcome
    Assert.NotNull(result);
}
```

### Test Isolation

```csharp
// ✅ GOOD: Each test uses unique database
[Fact]
public void Test1()
{
    var options = new DbContextOptionsBuilder<ApplicationDbContext>()
        .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
        .Options;
    // Test code...
}

// ❌ BAD: Tests share database, can interfere with each other
[Fact]
public void Test2()
{
    var options = new DbContextOptionsBuilder<ApplicationDbContext>()
        .UseInMemoryDatabase(databaseName: "SharedDb")
        .Options;
    // Test code...
}
```

---

## Document Information

**Document Version**: 1.0
**Last Updated**: October 4, 2025
**Related Documents**:
- [Code Examples](./code-examples.md)
- [API Services](../04-backend/api-services.md)
- [System Overview](../01-overview/system-overview.md)
