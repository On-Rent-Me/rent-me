# Entity Framework 6 Reference Guide

**Last Updated**: October 4, 2025

This document provides a comprehensive guide to Entity Framework 6 usage in the RentMe project, including entity patterns, LINQ queries, migrations, and best practices.

---

## Overview

RentMe uses **Entity Framework 6.2.0** as its ORM (Object-Relational Mapper) for database access. Entity Framework provides:

- Database-first, code-first, or model-first approaches
- LINQ query support
- Automatic change tracking
- Migration management
- Lazy/eager loading of related entities

---

## Data Layer Structure

```
📂 Production/RentMe.Data/               ⭐ DATA ACCESS LAYER
│
├── 🗄️  Identity/                        WHERE: DbContext (main EF class)
│   └── ApplicationDbContext.cs          DbSets, configuration
│       📝 CONTAINS: 30+ DbSet<Entity> properties
│       ⚙️  LIKE: TypeORM DataSource, Sequelize instance
│
├── 🎭 Entities/                         WHERE: Database models
│   ├── Property.cs                      Properties table
│   ├── ApplicationUser.cs               Users table (ASP.NET Identity)
│   ├── Bid.cs                           Bids table
│   ├── LeasePeriod.cs                   Leases table
│   ├── Billings/                        Billing entities folder
│   │   ├── Billing.cs
│   │   ├── BillingPayment.cs
│   │   ├── BillingCharge.cs
│   │   └── (more billing entities)
│   ├── RentalApplications/              Application entities folder
│   ├── Maintenance/                     Maintenance entities folder
│   └── (100+ entity files)
│   📝 PATTERN: Classes with properties, navigation properties
│   ⚙️  LIKE: TypeORM @Entity() classes, Sequelize models
│
├── 🔄 Migrations/                       WHERE: Database migrations
│   ├── 202001011200_InitialCreate.cs
│   ├── 202001021400_AddBillingTables.cs
│   └── (318 migration files!)
│   ⚙️  WHAT: Schema changes over time
│   📝 LIKE: Prisma migrations, TypeORM migrations
│
├── 🧩 Extensions/                       WHERE: Extension methods
│   └── PropertyExtensions.cs            Helper methods for entities
│
└── 📝 ApplicationDbContext.cs           Main database context
    ⚙️  CONTAINS:
        - DbSet properties for each table
        - OnModelCreating() for EF configuration
        - Connection string reference
```

---

## Entity Pattern

Entities are C# classes that map to database tables using data annotations and fluent API configuration.

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

### Key Entity Concepts

| Attribute | Purpose | SQL Equivalent |
|-----------|---------|----------------|
| `[Table("TableName")]` | Maps class to table | `CREATE TABLE TableName` |
| `[Key]` | Primary key | `PRIMARY KEY` |
| `[Required]` | NOT NULL constraint | `NOT NULL` |
| `[StringLength(n)]` | Max length | `VARCHAR(n)` |
| `[Column(TypeName = "...")]` | SQL data type | `DECIMAL(18,2)`, etc. |
| `[ForeignKey("PropertyName")]` | Foreign key | `FOREIGN KEY` |
| `[NotMapped]` | Exclude from DB | N/A (computed property) |
| `virtual` | Enable lazy loading | N/A (EF proxy) |

---

## DbContext Configuration

### ApplicationDbContext

**File**: `Production/RentMe.Data/Identity/ApplicationDbContext.cs`

```csharp
using System.Data.Entity;
using RentMe.Data.Entities;

namespace RentMe.Data.Identity
{
    public class ApplicationDbContext : DbContext
    {
        // Constructor
        public ApplicationDbContext()
            : base("DefaultConnection")  // Connection string name
        {
        }

        // DbSets (one per table)
        public DbSet<Property> Properties { get; set; }
        public DbSet<ApplicationUser> Users { get; set; }
        public DbSet<LeasePeriod> LeasePeriods { get; set; }
        public DbSet<Billing> Billings { get; set; }
        public DbSet<BillingPayment> BillingPayments { get; set; }
        public DbSet<BillingCharge> BillingCharges { get; set; }
        public DbSet<RentalApplication> RentalApplications { get; set; }
        public DbSet<MaintenanceRequest> MaintenanceRequests { get; set; }
        public DbSet<PropertyPhoto> PropertyPhotos { get; set; }
        public DbSet<Bid> Bids { get; set; }
        // ... 30+ more DbSets

        // Fluent API configuration
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure Property entity
            modelBuilder.Entity<Property>()
                .HasRequired(p => p.User)  // Required relationship
                .WithMany()  // User can have many properties
                .HasForeignKey(p => p.UserId)
                .WillCascadeOnDelete(false);  // Don't cascade deletes

            // Configure decimal precision
            modelBuilder.Entity<Property>()
                .Property(p => p.Rent)
                .HasPrecision(18, 2);

            modelBuilder.Entity<Property>()
                .Property(p => p.Deposit)
                .HasPrecision(18, 2);

            // Configure indexes
            modelBuilder.Entity<Property>()
                .HasIndex(p => p.City);

            modelBuilder.Entity<Property>()
                .HasIndex(p => p.State);

            modelBuilder.Entity<Property>()
                .HasIndex(p => new { p.City, p.State });  // Composite index

            // Configure Billing relationships
            modelBuilder.Entity<Billing>()
                .HasMany(b => b.Payments)
                .WithRequired(p => p.Billing)
                .HasForeignKey(p => p.BillingId);

            modelBuilder.Entity<Billing>()
                .HasMany(b => b.Charges)
                .WithRequired(c => c.Billing)
                .HasForeignKey(c => c.BillingId);
        }
    }
}
```

---

## LINQ Query Examples

LINQ (Language Integrated Query) allows querying databases using C# syntax.

### Basic Queries

```csharp
// 1️⃣ RETRIEVE ALL
var properties = _context.Properties.ToList();

// 2️⃣ FILTER (WHERE)
var activeProperties = _context.Properties
    .Where(p => p.IsActive)
    .ToList();

// 3️⃣ FILTER WITH MULTIPLE CONDITIONS
var properties = _context.Properties
    .Where(p => p.IsActive && !p.IsDeleted)
    .Where(p => p.City == "Austin")
    .Where(p => p.Rent >= 1000 && p.Rent <= 2000)
    .ToList();

// 4️⃣ ORDER BY
var properties = _context.Properties
    .Where(p => p.IsActive)
    .OrderBy(p => p.Rent)  // Ascending
    .ToList();

var properties = _context.Properties
    .Where(p => p.IsActive)
    .OrderByDescending(p => p.DateCreated)  // Descending
    .ToList();

// 5️⃣ PAGINATION
var properties = _context.Properties
    .Where(p => p.IsActive)
    .OrderBy(p => p.Rent)
    .Skip(0)   // Offset (page * pageSize)
    .Take(15)  // Limit (pageSize)
    .ToList();

// 6️⃣ SINGLE RECORD
var property = _context.Properties
    .SingleOrDefault(p => p.Id == 1);  // Returns null if not found

var property = _context.Properties
    .FirstOrDefault(p => p.City == "Austin");  // Returns first match or null
```

### Eager Loading (Prevent N+1 Queries)

```csharp
// ❌ BAD: N+1 queries (lazy loading)
var properties = _context.Properties.ToList();  // 1 query
foreach (var property in properties)
{
    var owner = property.User;  // N queries (one per property)
    var photos = property.Photos;  // N more queries
}
// Total: 1 + N + N queries

// ✅ GOOD: Single query with JOINs
var properties = _context.Properties
    .Include(p => p.User)    // JOIN AspNetUsers
    .Include(p => p.Photos)  // JOIN PropertyPhotos
    .ToList();  // 1 query total

foreach (var property in properties)
{
    var owner = property.User;  // No extra query, already loaded
    var photos = property.Photos;  // No extra query, already loaded
}
```

### Complex Queries

```csharp
// 1️⃣ AGGREGATIONS
var avgRent = _context.Properties
    .Where(p => p.City == "Austin")
    .Average(p => p.Rent);

var totalProperties = _context.Properties
    .Count(p => p.IsActive);

var maxRent = _context.Properties
    .Max(p => p.Rent);

var minRent = _context.Properties
    .Min(p => p.Rent);

// 2️⃣ GROUPING
var propertiesByCity = _context.Properties
    .GroupBy(p => p.City)
    .Select(g => new
    {
        City = g.Key,
        Count = g.Count(),
        AvgRent = g.Average(p => p.Rent),
        MaxRent = g.Max(p => p.Rent)
    })
    .ToList();

// 3️⃣ JOINS (Manual)
var propertiesWithOwners = _context.Properties
    .Join(_context.Users,
        p => p.UserId,
        u => u.Id,
        (p, u) => new
        {
            PropertyId = p.Id,
            Address = p.Address,
            Rent = p.Rent,
            OwnerName = u.Name,
            OwnerEmail = u.Email
        })
    .ToList();

// 4️⃣ SUBQUERIES
var usersWithProperties = _context.Users
    .Where(u => _context.Properties.Any(p => p.UserId == u.Id))
    .ToList();

// 5️⃣ CONTAINS (IN operator)
var cities = new[] { "Austin", "Dallas", "Houston" };
var properties = _context.Properties
    .Where(p => cities.Contains(p.City))
    .ToList();
// SQL: WHERE City IN ('Austin', 'Dallas', 'Houston')

// 6️⃣ LIKE operator
var properties = _context.Properties
    .Where(p => p.Address.Contains("Main"))  // LIKE '%Main%'
    .ToList();

var properties = _context.Properties
    .Where(p => p.Address.StartsWith("123"))  // LIKE '123%'
    .ToList();

var properties = _context.Properties
    .Where(p => p.Address.EndsWith("St"))  // LIKE '%St'
    .ToList();
```

### Projections (Select specific fields)

```csharp
// Return only specific fields
var properties = _context.Properties
    .Where(p => p.IsActive)
    .Select(p => new
    {
        p.Id,
        p.Address,
        p.Rent,
        OwnerName = p.User.Name  // Include related data
    })
    .ToList();

// Map to DTO
var properties = _context.Properties
    .Where(p => p.IsActive)
    .Select(p => new PropertyListModel
    {
        Id = p.Id,
        Address = p.Address,
        City = p.City,
        State = p.State,
        Rent = p.Rent,
        PhotoUrl = p.Photos.FirstOrDefault().Url
    })
    .ToList();
```

---

## CRUD Operations

### Create

```csharp
// Add single entity
var property = new Property
{
    Address = "123 Main St",
    City = "Austin",
    State = "TX",
    Rent = 1500,
    IsActive = true,
    DateCreated = DateTime.UtcNow
};

_context.Properties.Add(property);
_context.SaveChanges();  // Generates SQL INSERT

// property.Id now contains auto-generated ID
Console.WriteLine($"Created property with ID: {property.Id}");

// Add multiple entities
var properties = new List<Property>
{
    new Property { Address = "123 Main St", City = "Austin", Rent = 1500 },
    new Property { Address = "456 Oak Ave", City = "Dallas", Rent = 2000 }
};

_context.Properties.AddRange(properties);
_context.SaveChanges();
```

### Read

```csharp
// Find by primary key
var property = _context.Properties.Find(1);

// Find with conditions
var property = _context.Properties
    .FirstOrDefault(p => p.Address == "123 Main St");

// Get all
var properties = _context.Properties.ToList();

// Get with includes
var property = _context.Properties
    .Include(p => p.User)
    .Include(p => p.Photos)
    .FirstOrDefault(p => p.Id == 1);
```

### Update

```csharp
// Find and modify
var property = _context.Properties.Find(1);
if (property != null)
{
    property.Rent = 1600;
    property.DateModified = DateTime.UtcNow;

    _context.SaveChanges();  // Generates SQL UPDATE
}

// Attach and modify (when entity not tracked)
var property = new Property { Id = 1 };
_context.Properties.Attach(property);
property.Rent = 1600;
_context.Entry(property).Property(p => p.Rent).IsModified = true;
_context.SaveChanges();
```

### Delete

```csharp
// Hard delete (actually remove from DB)
var property = _context.Properties.Find(1);
if (property != null)
{
    _context.Properties.Remove(property);
    _context.SaveChanges();  // Generates SQL DELETE
}

// Soft delete (mark as deleted)
var property = _context.Properties.Find(1);
if (property != null)
{
    property.IsDeleted = true;
    property.DateDeleted = DateTime.UtcNow;
    _context.SaveChanges();  // Generates SQL UPDATE
}
```

---

## Migrations

Entity Framework uses migrations to manage database schema changes over time.

### Creating Migrations

```bash
# Package Manager Console
Add-Migration InitialCreate
Add-Migration AddBillingTables
Add-Migration AddPropertyPhotos

# .NET CLI
dotnet ef migrations add InitialCreate
```

### Applying Migrations

```bash
# Package Manager Console
Update-Database

# Apply to specific migration
Update-Database -TargetMigration AddBillingTables

# .NET CLI
dotnet ef database update
```

### Migration File Example

**File**: `RentMe.Data/Migrations/202001011200_AddPropertyPhotos.cs`

```csharp
namespace RentMe.Data.Migrations
{
    using System.Data.Entity.Migrations;

    public partial class AddPropertyPhotos : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.PropertyPhotos",
                c => new
                {
                    Id = c.Int(nullable: false, identity: true),
                    PropertyId = c.Int(nullable: false),
                    Url = c.String(maxLength: 500),
                    IsPrimary = c.Boolean(nullable: false),
                    DateCreated = c.DateTime(nullable: false),
                })
                .PrimaryKey(t => t.Id)
                .ForeignKey("dbo.Properties", t => t.PropertyId, cascadeDelete: true)
                .Index(t => t.PropertyId);
        }

        public override void Down()
        {
            DropForeignKey("dbo.PropertyPhotos", "PropertyId", "dbo.Properties");
            DropIndex("dbo.PropertyPhotos", new[] { "PropertyId" });
            DropTable("dbo.PropertyPhotos");
        }
    }
}
```

---

## Best Practices

### 1. Use AsNoTracking for Read-Only Queries

```csharp
// ✅ GOOD: Read-only, faster
var properties = _context.Properties
    .AsNoTracking()
    .Where(p => p.IsActive)
    .ToList();

// ❌ BAD: Unnecessary change tracking overhead
var properties = _context.Properties
    .Where(p => p.IsActive)
    .ToList();
```

### 2. Always Use Include for Related Data

```csharp
// ✅ GOOD: Single query with JOIN
var property = _context.Properties
    .Include(p => p.User)
    .Include(p => p.Photos)
    .FirstOrDefault(p => p.Id == 1);

// ❌ BAD: N+1 queries
var property = _context.Properties.FirstOrDefault(p => p.Id == 1);
var user = property.User;  // Extra query
var photos = property.Photos.ToList();  // Extra query
```

### 3. Dispose DbContext Properly

```csharp
// ✅ GOOD: Using statement ensures disposal
using (var context = new ApplicationDbContext())
{
    var properties = context.Properties.ToList();
}

// ✅ ALSO GOOD: With dependency injection (disposed by container)
public class PropertyService
{
    private readonly ApplicationDbContext _context;

    public PropertyService(ApplicationDbContext context)
    {
        _context = context;  // Disposed by DI container
    }
}
```

### 4. Use Transactions for Multiple Operations

```csharp
using (var transaction = _context.Database.BeginTransaction())
{
    try
    {
        _context.Properties.Add(newProperty);
        _context.SaveChanges();

        _context.PropertyPhotos.AddRange(photos);
        _context.SaveChanges();

        transaction.Commit();
    }
    catch
    {
        transaction.Rollback();
        throw;
    }
}
```

---

## Document Information

**Document Version**: 1.0
**Last Updated**: October 4, 2025
**Related Documents**:
- [Code Examples](../10-development/code-examples.md)
- [API Services](../04-backend/api-services.md)
- [System Overview](../01-overview/system-overview.md)
