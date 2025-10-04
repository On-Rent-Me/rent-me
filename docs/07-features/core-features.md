# Core Features

This document covers the foundational features of the RentMe platform, including user management, property management, and rental applications.

---

## 1. User Management & Authentication

### User Registration & Onboarding

- ✅ Email/password registration for landlords and tenants
- ✅ Email verification with confirmation links
- ✅ User profile creation (name, phone, bio, profile photo)
- ✅ User type selection (Landlord, Tenant, Admin)
- ✅ Account approval workflow for landlords
- ✅ Password strength validation
- ✅ Terms of Service and Privacy Policy acceptance
- ✅ Welcome email sequences

### Authentication & Security

- ✅ Secure login with OAuth 2.0 bearer tokens
- ✅ JWT token-based authentication (24-hour expiration)
- ✅ Password reset via email with time-limited tokens
- ✅ "Remember me" functionality
- ✅ Account lockout after failed login attempts
- ✅ Two-factor authentication support (infrastructure ready)
- ✅ Session management and timeout
- ✅ IP tracking for security auditing

### User Profile Management

- ✅ Edit profile information (name, email, phone, bio)
- ✅ Upload and manage profile photo (Azure Blob Storage)
- ✅ Update contact preferences
- ✅ Change password with current password verification
- ✅ Email change with re-verification
- ✅ Phone number verification
- ✅ Account deactivation/deletion
- ✅ Privacy settings management

### Authorization & Permissions

- ✅ Role-based access control (Landlord, Tenant, Admin, Manager)
- ✅ Resource-based authorization (property ownership verification)
- ✅ Company-level permissions (Owner, Manager, ReadOnly)
- ✅ Multi-tenancy support via companies
- ✅ Permission inheritance and delegation
- ✅ Audit trail for permission changes

---

## 2. Property Management

### Property Listing & Creation

- ✅ Create new property listings
- ✅ Property details (address, city, state, zip, unit number)
- ✅ Property specifications (bedrooms, bathrooms, square footage)
- ✅ Property descriptions and highlights (rich text/markdown)
- ✅ Location details and neighborhood information
- ✅ Amenities and features (via tags)
- ✅ Rental terms (rent amount, deposit, lease type)
- ✅ Pet policy configuration
- ✅ Smoking policy
- ✅ Furnished/unfurnished designation
- ✅ Room-for-rent vs. whole unit designation
- ✅ Legal owner name documentation
- ✅ Property groups/portfolios for organization
- ✅ Clone/duplicate properties for similar listings

### Property Photos & Media

- ✅ Upload multiple photos per property
- ✅ Drag-and-drop photo upload
- ✅ Automatic image optimization and thumbnails
- ✅ Set primary/featured photo
- ✅ Reorder photos via drag-and-drop
- ✅ Photo captions and descriptions
- ✅ Delete and replace photos
- ✅ Gallery view with lightbox
- ✅ Responsive image delivery (multiple resolutions)
- ✅ CDN-optimized image serving
- ✅ Maximum 20 photos per property

### Property Search & Discovery

- ✅ Public property search page
- ✅ Search by address, city, neighborhood
- ✅ Filter by bedrooms, bathrooms, price range
- ✅ Filter by amenities and features
- ✅ Filter by pet policy, furnished status
- ✅ Sort by price, date listed, relevance
- ✅ Map view with geolocation markers
- ✅ List view with property cards
- ✅ Grid view option
- ✅ Pagination (15 properties per page)
- ✅ Property detail page with all information
- ✅ Hide street address option (show only neighborhood)
- ✅ "Available Now" vs. future availability filtering
- ✅ Save favorite properties (tenant feature)

### Property Status Management

- ✅ Draft mode (not visible publicly)
- ✅ Active/Published (visible on site)
- ✅ Syndicated (active on partner sites)
- ✅ Rented status (no longer advertised)
- ✅ Archived properties
- ✅ Automatic status updates based on lease
- ✅ Date advertised tracking
- ✅ Date rented tracking
- ✅ Property deactivation and re-activation

### Property Notes & Documentation

- ✅ Internal property notes (landlord-only)
- ✅ Electrical service details
- ✅ Furnace filter size
- ✅ Year built and year acquired
- ✅ Purchase price tracking
- ✅ Appliance inventory with conditions
- ✅ Appliance serial numbers and models
- ✅ Move-in/move-out inspection checklists
- ✅ Attach documents to properties

### Property Portfolio Management

- ✅ Group properties into portfolios
- ✅ Multi-property dashboard for landlords
- ✅ Portfolio-level analytics
- ✅ Bulk operations on properties
- ✅ Export property data to CSV/Excel
- ✅ Property comparison tool

---

## 3. Rental Applications

### Application Submission (Tenant)

- ✅ Multi-step application wizard
- ✅ Personal information (name, DOB, SSN, driver's license)
- ✅ Contact information (email, phone numbers)
- ✅ Current and previous addresses (with landlord references)
- ✅ Employment history (multiple jobs)
- ✅ Income sources (employment + additional income)
- ✅ Asset value declaration
- ✅ Pet information (type, breed, weight, age)
- ✅ Vehicle information (make, model, year, license plate)
- ✅ Emergency contact information
- ✅ Personal references
- ✅ Social media profile links (LinkedIn, Facebook, Instagram, Twitter)
- ✅ Save and continue later functionality
- ✅ Application preview before submission
- ✅ Application fee payment (credit card via Braintree)
- ✅ Electronic signature (typed signature)
- ✅ Background check authorization

### Application Screening Questions

- ✅ "Have you ever been sued?"
- ✅ "Have you declared bankruptcy?"
- ✅ "Have you been convicted of a felony?"
- ✅ "Have you broken a lease?"
- ✅ "Have you been locked out by a sheriff?"
- ✅ "Have you been brought to court by a previous landlord?"
- ✅ "Have you moved owing damage compensation?"
- ✅ "Do you have total move-in amount available?"
- ✅ "Do you have a co-signer if needed?"
- ✅ Additional notes field

### Application Review (Landlord)

- ✅ View all applications for a property
- ✅ Filter applications by status (pending, approved, denied)
- ✅ Sort applications by date, credit score
- ✅ Review full application details
- ✅ View credit and background check results (if completed)
- ✅ Approve application
- ✅ Deny application with reason
- ✅ Request additional information/documents
- ✅ Add internal notes to application
- ✅ Compare multiple applications side-by-side
- ✅ Application status notifications to tenant
- ✅ Move application to lease creation

### Group Applications (Roommates)

- ✅ Create application group for multiple applicants
- ✅ Primary applicant creates group
- ✅ Invite co-applicants via email
- ✅ Co-applicants complete their portion
- ✅ Track invitation status and reminders
- ✅ Group submission (all must complete)
- ✅ Landlord reviews group as single unit
- ✅ Remove member from group
- ✅ Group approval/denial
- ✅ Link group to lease period

### Application Management

- ✅ Tenant views their submitted applications
- ✅ Tenant withdraws application before review
- ✅ Tenant tracks application status
- ✅ Application expiration (auto-archive after 90 days)
- ✅ Application history and audit trail
- ✅ Re-use application data for other properties

---

## Feature Summary by User Type

### Landlord Features (Property & Application Management)

- Property listing creation and management
- Photo upload and gallery management
- Application review and approval workflow
- Property portfolio organization
- Internal notes and documentation
- Multiple property status tracking
- Bulk operations and export capabilities

### Tenant Features (Application & Search)

- Property search with advanced filtering
- Application submission with wizard interface
- Save favorite properties
- Track application status
- Reuse application data
- Social media profile integration
- Electronic signature support

### Admin Features (User & Property Oversight)

- User approval and management
- Property moderation
- System-wide metrics and analytics
- Permission management
- Audit trail access
