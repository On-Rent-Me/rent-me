# RentMe - Complete System Documentation

## Table of Contents
1. [System Overview](#system-overview)
2. [Architecture & Technology Stack](#architecture--technology-stack)
3. [Complete Feature List](#complete-feature-list)
4. [Database Schema (Complete ERD)](#database-schema-complete-erd)
5. [Domain Model & Database Schema](#domain-model--database-schema)
6. [Core Features & Business Logic](#core-features--business-logic)
7. [API Endpoints](#api-endpoints)
8. [Frontend Application](#frontend-application)
9. [Third-Party Integrations](#third-party-integrations)
10. [Background Jobs & Scheduled Tasks](#background-jobs--scheduled-tasks)
11. [Authentication & Authorization](#authentication--authorization)
12. [Infrastructure & DevOps](#infrastructure--devops)
13. [Migration Considerations](#migration-considerations)

---

## System Overview

**RentMe** is a comprehensive property rental management platform that connects landlords and tenants, facilitating the entire rental lifecycle from property listing to lease management, rent collection, and maintenance requests.

### Core Value Propositions

**For Landlords:**
- Property listing and syndication to major rental sites (Zillow, HotPads)
- Tenant screening with credit checks (TransUnion SmartMove)
- Online rent collection with ACH and credit card processing
- Automated billing and late fee management
- Maintenance request tracking
- Credit reporting for tenants (TransUnion ShareAble)
- Renters insurance management

**For Tenants:**
- Property search and application submission
- Online rent payment
- Credit building through rent payment reporting
- Maintenance request submission
- Lease document access
- Communication with landlords

### User Roles
1. **Landlord** - Property owners managing rentals
2. **Tenant** - Renters leasing properties
3. **Admin** - System administrators
4. **PropertyManager** - Managers with company-level access

---

## Architecture & Technology Stack

### Current Technology Stack

#### Backend
- **Framework:** ASP.NET Web API 2 (.NET Framework 4.6.1)
- **Language:** C#
- **ORM:** Entity Framework 6
- **Database:** Microsoft SQL Server
- **Authentication:** ASP.NET Identity with OWIN OAuth 2.0
- **Dependency Injection:** Autofac
- **Object Mapping:** AutoMapper 6.2.2
- **Background Jobs:** Hangfire 1.6.17
- **Email:** SendGrid 9.8.0
- **Logging:** Application Insights, custom logging framework
- **Cloud Storage:** Azure Blob Storage
- **Payment Processing:** Braintree 5.15.0, ProfitStars (ACH)

#### Frontend
- **Framework:** AngularJS 1.5.11
- **Router:** UI-Router 1.0.13
- **UI Components:** Angular UI Bootstrap 2.5.6
- **Build Tool:** Grunt
- **CSS:** SASS
- **Charts:** ApexCharts 3.6.7
- **Animations:** AOS (Animate On Scroll) 2.3.4
- **File Upload:** ng-file-upload 12.0.4
- **Maps:** ngMap 1.18.4
- **Utilities:** Lodash 4.x

#### Infrastructure
- **Hosting:** Azure Web Apps
- **Serverless:** Azure Functions (background processing)
- **Storage:** Azure Blob Storage (images, documents)
- **CDN:** Azure CDN
- **CI/CD:** Azure DevOps (TFS)
- **Monitoring:** Application Insights

### Project Structure

```
RentMe/
├── Dev/                                    # Main development environment
├── Dev-Design/                             # UI/UX design branch
├── Dev-Payments/                           # Payment integration branch
├── Dev-Rent/                               # Core rental features branch
├── Dev-ShareAble/                          # Credit reporting branch
├── Production/                             # Production environment
└── BuildProcessTemplates/                  # Build configuration templates
```

### Core Projects

#### Backend Services
- **RentMe.Web.Api** - REST API controllers and HTTP services
- **RentMe.Data** - Entity Framework data layer, entities, migrations
- **RentMe.Common** - Shared utilities, enumerations, constants
- **RentMe.Utilities** - Helper functions and extensions
- **RentMe.Web.Common** - Web-specific shared code
- **RentMe.Web.Models** - DTOs and view models
- **RentMe.Logging** - Application logging and telemetry

#### Integration Services
- **RentMe.ProfitStarsIntegration** - ACH payment processing
- **RentMe.TransUnionShareAble** - Credit reporting to TransUnion
- **RentMe.SureAppIntegration** - Renters insurance
- **RentMe.MailChimp** - Marketing automation
- **RentMe.ImageProcessing** - Image optimization

#### Infrastructure Services
- **RentMe.AzureFunctions** - Serverless background processing
- **RentMe.AzureFunctions.Common** - Shared Azure Functions utilities
- **RentMe.Web.ShortLinksApp** - URL shortening service
- **RentMe.Web.BlogApi** - CMS/blog integration
- **RentMe.Web.Prerender** - SEO pre-rendering

#### Frontend
- **RentMe.Web.SPA** - AngularJS single-page application

#### Testing
- **RentMe.*.Tests** - Unit and integration tests for all projects
- **RentMe.Tests.Common** - Shared test utilities

---

## Complete Feature List

This section provides an exhaustive list of all features implemented in the RentMe platform, organized by functional area.

### 1. User Management & Authentication

#### User Registration & Onboarding
- ✅ Email/password registration for landlords and tenants
- ✅ Email verification with confirmation links
- ✅ User profile creation (name, phone, bio, profile photo)
- ✅ User type selection (Landlord, Tenant, Admin)
- ✅ Account approval workflow for landlords
- ✅ Password strength validation
- ✅ Terms of Service and Privacy Policy acceptance
- ✅ Welcome email sequences

#### Authentication & Security
- ✅ Secure login with OAuth 2.0 bearer tokens
- ✅ JWT token-based authentication (24-hour expiration)
- ✅ Password reset via email with time-limited tokens
- ✅ "Remember me" functionality
- ✅ Account lockout after failed login attempts
- ✅ Two-factor authentication support (infrastructure ready)
- ✅ Session management and timeout
- ✅ IP tracking for security auditing

#### User Profile Management
- ✅ Edit profile information (name, email, phone, bio)
- ✅ Upload and manage profile photo (Azure Blob Storage)
- ✅ Update contact preferences
- ✅ Change password with current password verification
- ✅ Email change with re-verification
- ✅ Phone number verification
- ✅ Account deactivation/deletion
- ✅ Privacy settings management

#### Authorization & Permissions
- ✅ Role-based access control (Landlord, Tenant, Admin, Manager)
- ✅ Resource-based authorization (property ownership verification)
- ✅ Company-level permissions (Owner, Manager, ReadOnly)
- ✅ Multi-tenancy support via companies
- ✅ Permission inheritance and delegation
- ✅ Audit trail for permission changes

---

### 2. Property Management

#### Property Listing & Creation
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

#### Property Photos & Media
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

#### Property Search & Discovery
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

#### Property Status Management
- ✅ Draft mode (not visible publicly)
- ✅ Active/Published (visible on site)
- ✅ Syndicated (active on partner sites)
- ✅ Rented status (no longer advertised)
- ✅ Archived properties
- ✅ Automatic status updates based on lease
- ✅ Date advertised tracking
- ✅ Date rented tracking
- ✅ Property deactivation and re-activation

#### Property Notes & Documentation
- ✅ Internal property notes (landlord-only)
- ✅ Electrical service details
- ✅ Furnace filter size
- ✅ Year built and year acquired
- ✅ Purchase price tracking
- ✅ Appliance inventory with conditions
- ✅ Appliance serial numbers and models
- ✅ Move-in/move-out inspection checklists
- ✅ Attach documents to properties

#### Property Portfolio Management
- ✅ Group properties into portfolios
- ✅ Multi-property dashboard for landlords
- ✅ Portfolio-level analytics
- ✅ Bulk operations on properties
- ✅ Export property data to CSV/Excel
- ✅ Property comparison tool

---

### 3. Listing Syndication

#### Syndication Partners
- ✅ Zillow integration
- ✅ HotPads integration
- ✅ Native OnRentMe.com listings
- ✅ Enable/disable syndication per property
- ✅ Selective partner syndication

#### Syndication Features
- ✅ One-click syndication to all partners
- ✅ Automatic listing formatting per partner specs
- ✅ Photo optimization for each partner
- ✅ Property description adaptation
- ✅ Contact information management
- ✅ Availability calendar sync
- ✅ Pricing updates propagation
- ✅ Automatic deactivation when rented
- ✅ Manual listing pause/unpause
- ✅ Syndication status tracking per partner
- ✅ Error handling and retry logic
- ✅ Scheduled re-sync (every 4 hours for Zillow)
- ✅ Syndication analytics and performance metrics

#### Syndication Billing
- ✅ Free syndication to OnRentMe.com
- ✅ Paid syndication to Zillow (premium placement)
- ✅ Paid syndication to HotPads
- ✅ Track syndication charges per property
- ✅ Date advertised on free vs. paid networks
- ✅ Syndication fee invoicing
- ✅ Auto-charge for active paid syndication
- ✅ Syndication cost reports

---

### 4. Rental Applications

#### Application Submission (Tenant)
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

#### Application Screening Questions
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

#### Application Review (Landlord)
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

#### Group Applications (Roommates)
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

#### Application Management
- ✅ Tenant views their submitted applications
- ✅ Tenant withdraws application before review
- ✅ Tenant tracks application status
- ✅ Application expiration (auto-archive after 90 days)
- ✅ Application history and audit trail
- ✅ Re-use application data for other properties

---

### 5. Credit & Background Checks

#### TransUnion SmartMove Integration
- ✅ Landlord enables background checks per property
- ✅ Set background check fee (passed to tenant)
- ✅ Tenant authorizes credit/background check
- ✅ Tenant pays application fee
- ✅ Initiate SmartMove screening via API
- ✅ Redirect tenant to TransUnion for identity verification
- ✅ Webhook notification on completion
- ✅ Retrieve and display screening results

#### Screening Criteria Configuration
- ✅ Set minimum credit score requirement
- ✅ Configure income ratio (rent-to-income)
- ✅ Decline for open bankruptcies (with window)
- ✅ Include/exclude foreclosures
- ✅ Include/exclude medical collections
- ✅ Select screening product bundle (Basic, Plus, Premium)
- ✅ Custom screening criteria per property

#### Screening Results
- ✅ Credit score and range
- ✅ Credit report summary
- ✅ Criminal background check results
- ✅ Eviction history
- ✅ Income insights
- ✅ Identity verification status
- ✅ Recommendation indicator (approve/review/deny)
- ✅ Store screening results with application
- ✅ Historical screening data retention
- ✅ Re-pull report if needed (additional fee)

#### Landlord Application Screening
- ✅ Pass/fail indicators for each criterion
- ✅ Color-coded risk assessment
- ✅ Detailed report viewing
- ✅ Download PDF reports
- ✅ Share results with property managers
- ✅ Compliance with FCRA regulations

---

### 6. Bidding System (Auction-Style Leasing)

#### Bidding Configuration
- ✅ Create lease period with "Bidding" type
- ✅ Set minimum bid price
- ✅ Set optional "Rent It Now" price (buy-it-now)
- ✅ Set bidding start and end dates
- ✅ Enable/disable bidding per property

#### Bidding Process (Tenant)
- ✅ View current highest bid (or starting price)
- ✅ Place manual bid
- ✅ Automatic bidding (set max bid, auto-increment)
- ✅ Bid history for tenant
- ✅ Outbid notifications via email/SMS
- ✅ Withdraw bid before acceptance
- ✅ "Rent It Now" instant lease option

#### Bid Management (Landlord)
- ✅ View all bids for a property
- ✅ See bidder information (if authorized)
- ✅ Bid authorization system (pre-approve bidders)
- ✅ Accept bid and convert to lease
- ✅ Reject bid with reason
- ✅ Counter-offer functionality
- ✅ Bid expiration and auto-rejection
- ✅ Notification to winning bidder
- ✅ Notification to losing bidders

#### Bidding Security
- ✅ Prevent spam bids via authorization
- ✅ Grant bidding rights to specific users
- ✅ Require application completion before bidding
- ✅ Require background check before bidding (optional)
- ✅ Bid deposit/earnest money (optional)
- ✅ Bind accepted bid to lease agreement

---

### 7. Lease Management

#### Lease Creation
- ✅ Create lease period for property
- ✅ Set lease start and end dates
- ✅ Set "available from" date
- ✅ Lease type selection (Fixed, Month-to-Month, Bidding)
- ✅ Set rent amount
- ✅ Set deposit amount
- ✅ Lease name/identifier
- ✅ Lease details and terms (rich text)
- ✅ Link lease to property
- ✅ Upload signed lease document (PDF)
- ✅ Generate lease agreement from template (optional)

#### Tenant Management
- ✅ Add tenants to lease
- ✅ Set move-in date per tenant
- ✅ Set move-out date per tenant
- ✅ Multiple tenants per lease
- ✅ Primary tenant designation
- ✅ Co-signer support
- ✅ Tenant contact information
- ✅ Tenant emergency contacts

#### Lease Types
- ✅ **Fixed-Term Lease** (6, 12, 24 months)
- ✅ **Month-to-Month Lease** (rolling)
- ✅ **Bidding Lease** (converts to fixed after acceptance)
- ✅ Custom lease durations

#### Lease Lifecycle
- ✅ Draft lease (not active)
- ✅ Active lease (tenants moved in)
- ✅ Expiring lease (60-day notice)
- ✅ Lease renewal process
- ✅ Lease termination (early or on-time)
- ✅ Lease extension
- ✅ Lease modification with addendums
- ✅ Lease history and audit trail

#### Lease Renewal
- ✅ Auto-notification 60 days before expiration
- ✅ Landlord creates renewal offer
- ✅ Adjust rent for renewal (increase/decrease)
- ✅ Adjust terms for renewal
- ✅ Tenant accepts or declines renewal
- ✅ New lease period created upon acceptance
- ✅ Link old and new lease periods

#### Lease Termination
- ✅ Tenant-initiated early termination request
- ✅ Landlord-initiated eviction process
- ✅ Mutual termination agreement
- ✅ Early termination fee calculation
- ✅ Move-out inspection scheduling
- ✅ Security deposit return process
- ✅ Final billing and ledger settlement
- ✅ Termination date tracking

#### Lease Documents
- ✅ Upload signed lease agreement
- ✅ Upload lease addendums
- ✅ Upload move-in inspection reports
- ✅ Upload move-out inspection reports
- ✅ Document versioning and history
- ✅ Tenant access to lease documents
- ✅ Document download (PDF)
- ✅ E-signature integration (ready for future)

#### Renters Insurance Requirement
- ✅ Enable/disable insurance requirement per lease
- ✅ Set minimum coverage amount
- ✅ Track insurance policy status
- ✅ Insurance expiration reminders
- ✅ Automatic compliance monitoring
- ✅ Integration with SureApp for policy purchase

---

### 8. Rent Collection & Billing

#### Automated Recurring Billing
- ✅ Create auto-billing for recurring charges
- ✅ Monthly rent auto-billing
- ✅ Utilities billing (water, electric, gas, internet)
- ✅ Pet rent
- ✅ Parking fees
- ✅ Storage fees
- ✅ HOA fees
- ✅ Other custom recurring charges
- ✅ Set due day of month (1-31)
- ✅ Set billing frequency (monthly, quarterly, annual)
- ✅ Set start and end dates for auto-billing
- ✅ Service period tracking (for prorated charges)
- ✅ Automatic billing generation via scheduled task
- ✅ Enable/disable auto-billing
- ✅ Pause and resume auto-billing

#### Manual Billing
- ✅ Create one-time charges
- ✅ Late fees
- ✅ Damage charges
- ✅ Cleaning fees
- ✅ Lock-out fees
- ✅ NSF (Non-Sufficient Funds) fees
- ✅ Administrative fees
- ✅ Early termination fees
- ✅ Custom charges with description
- ✅ Set due date
- ✅ Link billing to specific service period

#### Billing Categories
- ✅ Rent
- ✅ Utilities
- ✅ Pet fees
- ✅ Parking
- ✅ Late fees
- ✅ Damage
- ✅ NSF fees
- ✅ Other/Custom

#### Late Fee Management
- ✅ Enable/disable late fees per billing
- ✅ Set late fee amount (fixed or percentage)
- ✅ Set grace period (days after due date)
- ✅ Automatic late fee assessment via scheduled task
- ✅ Manual late fee creation
- ✅ Late fee waiver by landlord
- ✅ Track late payment history
- ✅ Late payment notifications to tenant

#### Billing Adjustments & Corrections
- ✅ Edit billing amount before payment
- ✅ Prorate charges for partial periods
- ✅ Create credit adjustments
- ✅ Create correction billings (linked to original)
- ✅ Track full corrected amount
- ✅ Billing relationship tracking (parent/child)
- ✅ Audit trail for all changes

#### Billing Notifications
- ✅ Email notification when billing created
- ✅ Email reminder 7 days before due date
- ✅ Email reminder on due date
- ✅ Email notification when late
- ✅ SMS notifications (optional)
- ✅ In-app notification center
- ✅ Customizable notification preferences

---

### 9. Rent Payment Processing

#### Payment Methods (Tenant)
- ✅ **ACH Bank Transfer** (via ProfitStars)
  - Add bank account (routing + account number)
  - Micro-deposit verification (2-3 days)
  - Plaid instant verification (optional)
  - Save multiple bank accounts
  - Set default payment method
- ✅ **Credit/Debit Card** (via Braintree)
  - Add credit/debit card securely
  - PCI-compliant tokenization
  - Save multiple cards
  - Set default payment method
- ✅ **Manual Payment Recording** (Cash, Check, Money Order)
  - Landlord records manual payment
  - Attach payment receipt/photo
  - Manual reconciliation

#### Payment Initiation (Tenant)
- ✅ View outstanding balance
- ✅ View upcoming charges
- ✅ View payment history
- ✅ Select billing(s) to pay
- ✅ Pay multiple billings in one transaction
- ✅ Partial payments (if enabled)
- ✅ Pay full balance with one click
- ✅ Select payment method
- ✅ Add new payment method during checkout
- ✅ Review payment summary before confirmation
- ✅ Confirm payment with email receipt
- ✅ Schedule future payment (optional)

#### Automatic Payments
- ✅ Enable auto-pay for recurring charges
- ✅ Auto-pay on specific day of month
- ✅ Auto-pay percentage or amount of billing
- ✅ Auto-pay only when billing is created
- ✅ Auto-pay frequency configuration
- ✅ Auto-pay start and end dates
- ✅ Auto-pay notifications
- ✅ Disable auto-pay anytime
- ✅ Auto-pay failure handling and retries

#### Payment Processing
- ✅ **ACH Processing** (ProfitStars)
  - Immediate authorization
  - Batch processing (next business day)
  - 2-3 day settlement
  - Transaction status tracking
  - Webhook updates from ProfitStars
- ✅ **Credit Card Processing** (Braintree)
  - Real-time authorization
  - Immediate settlement
  - 3D Secure fraud protection
  - Instant confirmation
- ✅ Transaction ID tracking
- ✅ Payment effective date
- ✅ Payment creation date
- ✅ IP address logging for security

#### Transaction Fees
- ✅ System transaction fee (2-5% configurable per property)
- ✅ Processor fee (ACH: ~$1, CC: 2.9%+$0.30)
- ✅ Fee allocation (tenant pays, landlord pays, or split)
- ✅ Fee calculation and display before payment
- ✅ Separate transaction for system fees
- ✅ Fee reporting for landlords
- ✅ Fee revenue tracking for platform

#### Payment Confirmation & Receipts
- ✅ Email receipt immediately after payment
- ✅ PDF receipt generation
- ✅ Receipt includes transaction ID, amount, date, method
- ✅ In-app payment confirmation page
- ✅ Push notification for successful payment
- ✅ SMS confirmation (optional)

#### Payment History & Ledger
- ✅ Tenant views full payment history
- ✅ Landlord views full payment history per property
- ✅ Filter by date range
- ✅ Filter by payment method
- ✅ Filter by status (pending, completed, failed)
- ✅ Search by transaction ID
- ✅ Export payment history to CSV/Excel
- ✅ Running balance calculation (ledger)
- ✅ Aging report (30/60/90 days overdue)

#### Failed Payments & NSF Handling
- ✅ Payment failure notifications (email/SMS)
- ✅ NSF (Non-Sufficient Funds) fee automatic creation
- ✅ Retry failed ACH payments (configurable)
- ✅ Account closed detection
- ✅ Invalid routing number detection
- ✅ Fraud detection and blocking
- ✅ Payment failure reason tracking
- ✅ Landlord notification of failed payments
- ✅ Tenant account restrictions after multiple failures

#### Refunds
- ✅ Landlord initiates refund
- ✅ Full or partial refund
- ✅ Refund reason and notes
- ✅ Refund processing via original payment method
- ✅ Refund notification to tenant
- ✅ Refund tracking and audit trail
- ✅ Refund reporting

---

### 10. ProfitStars ACH Integration

#### Landlord Onboarding (Merchant Setup)
- ✅ Create ProfitStars application
- ✅ Collect business/personal information
- ✅ Tax ID (SSN or EIN) collection
- ✅ Bank account information (for deposits)
- ✅ Micro-deposit verification for landlord bank
- ✅ Submit application to ProfitStars
- ✅ Underwriting review (ProfitStars side)
- ✅ Approval/denial notification
- ✅ Merchant location (Entity ID) creation
- ✅ Set default transaction fee
- ✅ Enable/disable merchant location
- ✅ Track ACH setup status

#### Tenant Onboarding (Customer Setup)
- ✅ Create ProfitStars customer account
- ✅ Link customer to specific merchant (landlord)
- ✅ Add bank account information
- ✅ Verify bank account via micro-deposits
- ✅ Alternative: Plaid instant verification
- ✅ Account registration confirmation
- ✅ Store account reference ID
- ✅ Support multiple bank accounts per tenant

#### Payment Processing
- ✅ Initiate ACH transaction via API
- ✅ Debit from tenant account
- ✅ Credit to landlord merchant account
- ✅ Transaction batching (daily)
- ✅ Batch submission to ACH network
- ✅ Transaction status tracking (Pending → Processing → Settled)
- ✅ Settlement status tracking
- ✅ Effective date tracking
- ✅ Response code and message handling

#### Batch Management
- ✅ Fetch latest batches from ProfitStars
- ✅ Scheduled task to sync batch statuses (every 30 min)
- ✅ Update local batch records with ProfitStars data
- ✅ Link batch transactions to billing payments
- ✅ Reconcile batch amounts
- ✅ Handle batch-level errors
- ✅ Batch reporting for landlords

#### Transaction Event Tracking
- ✅ Scheduled task to fetch transaction events (every 15 min)
- ✅ Transaction status updates (Authorized, Scheduled, Settled, Failed)
- ✅ Settlement status updates
- ✅ Return handling (NSF, Account Closed, etc.)
- ✅ Webhook support for real-time updates
- ✅ Payment history audit trail
- ✅ Store all transaction events for compliance

#### Error Handling & Recovery
- ✅ NSF (Non-Sufficient Funds) detection and fee assessment
- ✅ Account closed error handling
- ✅ Invalid routing number detection
- ✅ Payment retry logic for transient errors
- ✅ Stuck batch detection and reprocessing
- ✅ Manual reconciliation tools for admins
- ✅ ProfitStars API error logging

---

### 11. Credit Reporting (TransUnion ShareAble)

#### Landlord Enrollment
- ✅ Opt-in to ShareAble program
- ✅ Property registration with TransUnion
- ✅ Receive ShareAble property ID
- ✅ Track enrollment status
- ✅ Manage enrolled properties

#### Tenant Enrollment
- ✅ Tenant opts in to credit reporting (free for tenant)
- ✅ TransUnion identity verification
- ✅ Receive ShareAble renter ID
- ✅ Link tenant to property
- ✅ Track enrollment status
- ✅ Opt-out capability

#### Rent Payment Reporting
- ✅ Scheduled monthly reporting task
- ✅ Identify completed rent payments for enrolled tenants
- ✅ Submit payment data to TransUnion API
- ✅ Report on-time payments
- ✅ Report late payments (optional)
- ✅ Report missed payments (optional)
- ✅ Payment amount and date reporting
- ✅ Track reporting status per payment
- ✅ Reporting confirmation from TransUnion
- ✅ Historical reporting data retention

#### Benefits Tracking
- ✅ Tenant credit score improvement tracking
- ✅ Landlord participation metrics
- ✅ Reporting success rate monitoring
- ✅ Marketing materials highlighting credit building

---

### 12. Renters Insurance (SureApp Integration)

#### Insurance Configuration
- ✅ Landlord enables insurance requirement per lease
- ✅ Set minimum coverage amount
- ✅ Set liability coverage requirement
- ✅ Optional vs. required insurance
- ✅ Track insurance compliance per tenant

#### Tenant Insurance Purchase
- ✅ Redirect to SureApp partner portal
- ✅ Pre-fill property and tenant information
- ✅ Tenant purchases policy through SureApp
- ✅ Multiple coverage options (basic, standard, premium)
- ✅ Add-on coverage (pet damage, water backup, earthquake, etc.)
- ✅ Deductible selection
- ✅ Payment frequency (monthly, annual)
- ✅ Instant policy issuance

#### Policy Management
- ✅ Sync policy data from SureApp to RentMe
- ✅ Store policy number, coverage amounts, premium
- ✅ Track policy effective and expiration dates
- ✅ Display policy status on tenant dashboard
- ✅ Policy renewal reminders (60, 30, 7 days before expiration)
- ✅ Expired policy alerts to landlord and tenant
- ✅ Upload proof of insurance (if purchased elsewhere)
- ✅ Document verification by landlord

#### Compliance Tracking
- ✅ Dashboard alerts for tenants without required insurance
- ✅ Scheduled task to check expiring policies (weekly)
- ✅ Email/SMS reminders to tenants
- ✅ Escalation to landlord for non-compliance
- ✅ Optional auto-billing for insurance premium (via lease billing)
- ✅ Compliance reports for landlords

---

### 13. Maintenance Requests

#### Tenant Submission
- ✅ Create new maintenance request
- ✅ Select property/unit
- ✅ Request title and description
- ✅ Select category (Plumbing, Electrical, HVAC, Appliance, Other)
- ✅ Set priority (Low, Medium, High, Emergency)
- ✅ Upload photos (before photos)
- ✅ Multiple photo upload support
- ✅ Preferred contact method
- ✅ Availability for repairs
- ✅ Submit request to landlord
- ✅ Track request status
- ✅ View request history

#### Landlord Management
- ✅ View all maintenance requests per property
- ✅ Filter by status (Submitted, Acknowledged, In Progress, Completed)
- ✅ Filter by priority
- ✅ Sort by date, priority
- ✅ Acknowledge request (change status)
- ✅ Add internal notes
- ✅ Assign to contractor/vendor
- ✅ Set estimated completion date
- ✅ Set estimated cost
- ✅ Update actual cost upon completion
- ✅ Upload photos (repair photos, after photos)
- ✅ Mark as completed
- ✅ Close request
- ✅ Reopen request if issue persists

#### Status Workflow
- ✅ **Submitted** - New request from tenant
- ✅ **Acknowledged** - Landlord has seen request
- ✅ **In Progress** - Work is being done
- ✅ **Completed** - Work finished
- ✅ **Cancelled** - Request cancelled by tenant or landlord

#### Priority Levels
- ✅ **Emergency** - Immediate attention (e.g., gas leak, no heat in winter)
- ✅ **High** - 24-48 hour response (e.g., broken toilet, no hot water)
- ✅ **Medium** - 1 week response (e.g., leaky faucet, broken appliance)
- ✅ **Low** - Non-urgent (e.g., cosmetic issues)

#### Notifications
- ✅ Landlord email notification on new request
- ✅ Landlord SMS notification for emergency requests
- ✅ Tenant email notification on status change
- ✅ Tenant notification when marked complete
- ✅ Scheduled digest email for pending requests (daily)
- ✅ Escalation alerts for overdue requests
- ✅ In-app notification center

#### Maintenance History
- ✅ Tenant views their maintenance request history
- ✅ Landlord views all maintenance for a property
- ✅ Filter by date range
- ✅ Filter by category
- ✅ Export to CSV/Excel
- ✅ Maintenance cost reporting
- ✅ Average response time metrics

#### Billing Integration
- ✅ Create billing from maintenance request (for tenant-caused damage)
- ✅ Link billing to maintenance request
- ✅ Track maintenance costs in ledger

---

### 14. Lead Management

#### Lead Capture
- ✅ Contact form on property detail page
- ✅ "Schedule Showing" button
- ✅ Phone number click-to-call
- ✅ Email inquiry form
- ✅ External lead import (Zillow, HotPads)
- ✅ Lead source tracking (Website, Zillow, HotPads, Referral, Other)
- ✅ Capture lead information (name, email, phone, message)
- ✅ Anonymous lead support (user not required to register)
- ✅ Registered user lead tracking

#### Lead Workflow
- ✅ Landlord receives email notification on new lead
- ✅ Landlord receives SMS notification (optional)
- ✅ Lead detail page with contact information
- ✅ Lead status tracking (New, Contacted, Scheduled, Completed, Lost)
- ✅ Add notes to lead
- ✅ Contact lead via email (within platform)
- ✅ Contact lead via SMS (within platform)
- ✅ Click-to-call phone integration
- ✅ Schedule showing appointment
- ✅ Mark lead as converted (application submitted)
- ✅ Mark lead as lost with reason

#### Showing Scheduling
- ✅ Set showing date and time
- ✅ Calendar integration (Google Calendar, iCal)
- ✅ Showing confirmation email to tenant
- ✅ Showing reminder email 24 hours before
- ✅ Showing reminder SMS 1 hour before
- ✅ Reschedule showing
- ✅ Cancel showing
- ✅ Mark showing as completed/no-show

#### Lead Analytics
- ✅ Leads dashboard for landlords
- ✅ Lead source breakdown
- ✅ Conversion rate by source
- ✅ Average time to contact
- ✅ Response rate metrics
- ✅ Showing-to-application conversion rate
- ✅ Lost lead analysis (reasons)
- ✅ Lead volume trends over time

#### Lead Communication
- ✅ In-app messaging between landlord and lead
- ✅ Email templates for common responses
- ✅ SMS templates for quick replies
- ✅ Communication history per lead
- ✅ Bulk email to multiple leads (optional)

---

### 15. Communication & Notifications

#### Email System (SendGrid)
- ✅ Transactional emails for all user actions
- ✅ Email templates with branding
- ✅ Personalization with user data
- ✅ HTML and plain text versions
- ✅ Responsive email design
- ✅ Email tracking (opens, clicks, bounces)
- ✅ Unsubscribe management
- ✅ Email preference center
- ✅ Bulk email campaigns (marketing)
- ✅ Email scheduling
- ✅ A/B testing support

#### Email Notifications
- ✅ Registration confirmation
- ✅ Email verification
- ✅ Password reset
- ✅ New application received (landlord)
- ✅ Application status update (tenant)
- ✅ New lead received (landlord)
- ✅ Payment received (tenant and landlord)
- ✅ Payment failed (tenant)
- ✅ Billing created (tenant)
- ✅ Billing due reminder (7 days, 1 day before)
- ✅ Late payment notice (tenant)
- ✅ Late fee assessed (tenant)
- ✅ Maintenance request submitted (landlord)
- ✅ Maintenance request status update (tenant)
- ✅ Lease expiring soon (60, 30 days before)
- ✅ Renters insurance expiring (60, 30, 7 days before)
- ✅ Showing scheduled (tenant and landlord)
- ✅ Showing reminder (24 hours, 1 hour before)
- ✅ Weekly digest for landlords (pending items)
- ✅ Monthly statement (tenant)

#### SMS System (Telnyx)
- ✅ Two-way SMS messaging
- ✅ SMS notifications for critical events
- ✅ SMS opt-in/opt-out management
- ✅ Phone number validation
- ✅ Carrier lookup
- ✅ SMS delivery tracking
- ✅ SMS rate limiting
- ✅ SMS reply handling
- ✅ SMS-to-email gateway for landlords

#### SMS Notifications
- ✅ Emergency maintenance request (landlord)
- ✅ Payment received confirmation (tenant)
- ✅ Payment failed alert (tenant)
- ✅ New lead (landlord, optional)
- ✅ Showing reminder (1 hour before)
- ✅ Application approved/denied (tenant, optional)
- ✅ Lease expiring soon (tenant, optional)

#### In-App Notifications
- ✅ Notification bell icon with count
- ✅ Notification center/inbox
- ✅ Mark as read/unread
- ✅ Delete notifications
- ✅ Notification categories (Payments, Applications, Maintenance, etc.)
- ✅ Filter notifications by category
- ✅ Real-time notifications (push via SignalR infrastructure)
- ✅ Notification history retention (90 days)

#### Communication Preferences
- ✅ User preference center
- ✅ Enable/disable email notifications per category
- ✅ Enable/disable SMS notifications
- ✅ Set preferred contact method (email, SMS, both)
- ✅ Notification frequency (immediate, daily digest, weekly digest)
- ✅ Quiet hours for SMS

#### In-App Messaging
- ✅ Message landlord from property detail page
- ✅ Message tenant from application
- ✅ Message threads per property/lease
- ✅ Attach files to messages
- ✅ Mark messages as read/unread
- ✅ Message search
- ✅ Email notification when new message received

---

### 16. Dashboards & Analytics

#### Tenant Dashboard
- ✅ Current lease information
- ✅ Upcoming rent payment due
- ✅ Outstanding balance display
- ✅ Payment history summary
- ✅ Quick pay button
- ✅ Recent transactions
- ✅ Active maintenance requests
- ✅ Submitted applications status
- ✅ Insurance policy status
- ✅ Lease documents access
- ✅ Notifications/alerts
- ✅ Saved favorite properties

#### Landlord Dashboard
- ✅ Portfolio overview (total properties, occupied, vacant)
- ✅ Revenue summary (current month, YTD)
- ✅ Outstanding rent (total, by property)
- ✅ Recent payments
- ✅ Pending applications
- ✅ Active maintenance requests
- ✅ Expiring leases (next 60 days)
- ✅ Recent leads
- ✅ Occupancy rate
- ✅ Average rent per property
- ✅ Quick actions (create property, review application, etc.)
- ✅ Notifications/alerts
- ✅ Calendar of showings and important dates

#### Property Analytics
- ✅ Property-level revenue
- ✅ Occupancy history
- ✅ Average lease duration
- ✅ Rent price history
- ✅ Days vacant vs. occupied
- ✅ Tenant turnover rate
- ✅ Maintenance cost per property
- ✅ Application-to-lease conversion rate
- ✅ Lead-to-application conversion rate

#### Revenue Reports
- ✅ Monthly revenue by property
- ✅ Year-over-year revenue comparison
- ✅ Revenue by category (rent, utilities, fees)
- ✅ Revenue projections
- ✅ Collected vs. outstanding rent
- ✅ Late payment trends
- ✅ Transaction fee breakdown
- ✅ Export to CSV/Excel/PDF

#### Occupancy Reports
- ✅ Current occupancy rate
- ✅ Historical occupancy trends
- ✅ Average days to rent
- ✅ Vacancy cost analysis
- ✅ Seasonal occupancy patterns
- ✅ Occupancy by property type
- ✅ Lease renewal rate

#### Maintenance Reports
- ✅ Maintenance costs by property
- ✅ Maintenance costs by category
- ✅ Average response time
- ✅ Average cost per request
- ✅ Request volume trends
- ✅ Maintenance by priority
- ✅ Vendor/contractor spending

#### Application Reports
- ✅ Applications by status
- ✅ Average credit score of applicants
- ✅ Approval vs. denial rate
- ✅ Application source breakdown
- ✅ Time to decision
- ✅ Background check utilization
- ✅ Application fee revenue

---

### 17. Document Management

#### Document Upload
- ✅ Upload lease agreements (PDF)
- ✅ Upload addendums
- ✅ Upload inspection reports (move-in, move-out)
- ✅ Upload W-9 forms
- ✅ Upload identification (driver's license, passport)
- ✅ Upload paystubs/proof of income
- ✅ Upload insurance certificates
- ✅ Upload other documents
- ✅ Drag-and-drop upload
- ✅ Multiple file upload
- ✅ File size limit (10MB per file)
- ✅ Accepted formats (PDF, JPG, PNG, DOCX, XLSX)

#### Document Storage
- ✅ Azure Blob Storage for all documents
- ✅ Secure URLs with expiration
- ✅ Encrypted storage for sensitive documents
- ✅ Document versioning
- ✅ Document metadata (name, type, upload date, uploader)
- ✅ Folder/category organization

#### Document Access
- ✅ Landlord accesses all property documents
- ✅ Tenant accesses their lease documents
- ✅ Download documents (original file)
- ✅ View documents in browser (PDF viewer)
- ✅ Share document links (time-limited)
- ✅ Document permissions (owner, shared)

#### Document Requests
- ✅ Landlord requests documents from tenant
- ✅ Document request types (W-9, Paystub, ID, etc.)
- ✅ Set due date for document
- ✅ Track request status (pending, fulfilled)
- ✅ Email notification to tenant
- ✅ Reminder emails for unfulfilled requests
- ✅ Tenant uploads requested documents
- ✅ Landlord reviews and marks as complete

---

### 18. Company Management (Multi-User Landlord Accounts)

#### Company Creation
- ✅ Create landlord company (LLC, Corporation, Individual)
- ✅ Company name and details
- ✅ Tax ID (EIN or SSN)
- ✅ Business address
- ✅ Contact information
- ✅ Upload company logo
- ✅ Website link
- ✅ Company bio/description

#### User Permissions
- ✅ Add users to company
- ✅ Permission levels:
  - **Owner** - Full control
  - **Manager** - Manage properties, tenants, billing
  - **ReadOnly** - View-only access
- ✅ Invite users via email
- ✅ Remove users from company
- ✅ Transfer ownership
- ✅ Permission-based UI (show/hide features)
- ✅ Audit log for permission changes

#### Company Features
- ✅ All properties under company
- ✅ Company-wide reporting
- ✅ Consolidated billing and payment tracking
- ✅ Company-level bank accounts (ProfitStars)
- ✅ Company-level credit cards (Braintree)
- ✅ Company-level settings
- ✅ Branding and customization

---

### 19. Administration & Support

#### Admin Dashboard
- ✅ System-wide metrics (users, properties, transactions)
- ✅ User growth charts
- ✅ Revenue metrics (transaction fees)
- ✅ Top properties by activity
- ✅ Recent registrations
- ✅ Failed payment summary
- ✅ System health monitoring
- ✅ Background job status

#### User Management (Admin)
- ✅ View all users (landlords, tenants, admins)
- ✅ Search and filter users
- ✅ View user details
- ✅ Approve pending landlord accounts
- ✅ Suspend user accounts
- ✅ Delete user accounts (soft delete)
- ✅ Reset user passwords
- ✅ Impersonate user (for support)
- ✅ View user activity log

#### Property Management (Admin)
- ✅ View all properties
- ✅ Search and filter properties
- ✅ Feature properties (premium placement)
- ✅ Remove inappropriate listings
- ✅ Edit property details (if needed)
- ✅ Property moderation queue

#### Transaction Management (Admin)
- ✅ View all transactions
- ✅ Search by transaction ID, user, property
- ✅ Filter by date, status, amount
- ✅ Refund transactions
- ✅ Manual transaction reconciliation
- ✅ Dispute resolution
- ✅ Transaction reporting
- ✅ Failed transaction analysis

#### System Configuration (Admin)
- ✅ Set system-wide transaction fee percentage
- ✅ Configure syndication fees
- ✅ Set rate limits per user type
- ✅ Manage email templates
- ✅ Configure notification settings
- ✅ Feature flags for A/B testing
- ✅ Maintenance mode toggle

#### System Limits Management
- ✅ Define system limits (properties per user, applications per month, etc.)
- ✅ Set limit values and reset periods
- ✅ Track usage tallies per user/company
- ✅ Automatic limit enforcement
- ✅ Upgrade prompts when limits reached

#### Support Features
- ✅ Support ticket system (optional future feature)
- ✅ In-app help documentation
- ✅ FAQ page
- ✅ Contact support form
- ✅ Knowledge base search
- ✅ Live chat (optional future feature)

---

### 20. Search Engine Optimization (SEO)

#### Property SEO
- ✅ Unique URL per property (`/property/{id}/{slug}`)
- ✅ SEO-friendly URL slugs (address-based)
- ✅ Meta title optimization per property
- ✅ Meta description optimization
- ✅ Open Graph tags for social sharing
- ✅ Twitter Card tags
- ✅ Structured data (schema.org) for properties
  - Real Estate Listing schema
  - Address schema
  - Offer schema
- ✅ Image alt tags optimization
- ✅ Canonical URL tags
- ✅ Mobile-responsive design (SEO ranking factor)

#### Sitemap
- ✅ Dynamic XML sitemap generation
- ✅ Include all active properties
- ✅ Update frequency tags
- ✅ Priority tags
- ✅ Submit to Google Search Console
- ✅ Submit to Bing Webmaster Tools

#### Pre-rendering (RentMe.Web.Prerender)
- ✅ Pre-render AngularJS SPA for search engines
- ✅ Headless browser rendering
- ✅ Serve static HTML to crawlers
- ✅ Maintain SPA experience for users
- ✅ Cache pre-rendered pages
- ✅ Automatic cache invalidation on content update

#### Content Optimization
- ✅ Property descriptions optimized for keywords
- ✅ Location-based keywords (city, neighborhood)
- ✅ Amenity-based keywords
- ✅ Internal linking between properties
- ✅ Blog integration for content marketing (RentMe.Web.BlogApi)

---

### 21. Security & Compliance

#### Data Security
- ✅ HTTPS enforcement (TLS 1.2+)
- ✅ HSTS headers
- ✅ Password hashing (PBKDF2)
- ✅ Secure token storage
- ✅ SQL injection prevention (parameterized queries)
- ✅ XSS prevention (output encoding)
- ✅ CSRF protection (anti-forgery tokens)
- ✅ Input validation on all forms
- ✅ File upload validation (type, size, content)

#### Payment Security
- ✅ PCI DSS compliance (via Braintree)
- ✅ Never store credit card numbers
- ✅ Tokenization for stored payment methods
- ✅ Hosted fields for card input (Braintree)
- ✅ 3D Secure fraud protection
- ✅ Transaction encryption in transit
- ✅ Bank account data encryption at rest

#### Data Privacy
- ✅ GDPR-ready features (data export, deletion)
- ✅ Privacy policy and terms of service
- ✅ Cookie consent banner
- ✅ User data export (JSON)
- ✅ Right to be forgotten (account deletion)
- ✅ Data retention policies
- ✅ SSN encryption (for applications)
- ✅ Secure document storage (Azure Blob)

#### Rate Limiting
- ✅ API rate limits per user/IP
- ✅ Login attempt rate limiting (prevent brute force)
- ✅ Photo upload rate limiting
- ✅ Email sending rate limiting
- ✅ SMS sending rate limiting
- ✅ 429 Too Many Requests responses
- ✅ Redis-based rate limit tracking

#### Audit Logging
- ✅ User login/logout tracking
- ✅ Failed login attempts
- ✅ Payment transaction logs
- ✅ Application submission logs
- ✅ Property modification logs
- ✅ Permission change logs
- ✅ IP address tracking for all actions
- ✅ User agent tracking
- ✅ Audit log retention (7 years for financial data)

#### Compliance
- ✅ Fair Housing Act compliance (no discriminatory questions)
- ✅ FCRA compliance (background checks)
- ✅ ECOA compliance (Equal Credit Opportunity Act)
- ✅ State-specific rental law compliance
- ✅ California privacy law compliance (CCPA)
- ✅ Financial transaction record retention

---

### 22. Performance & Scalability

#### Performance Optimization
- ✅ Azure CDN for static assets
- ✅ Image optimization and compression
- ✅ Lazy loading for images
- ✅ Database query optimization
- ✅ Database indexing on high-traffic columns
- ✅ Connection pooling
- ✅ Output caching for API responses
- ✅ Redis caching for session state
- ✅ Grunt build optimization (minification, concatenation)
- ✅ GZIP compression
- ✅ Async/await for I/O operations

#### Scalability
- ✅ Horizontal scaling (Azure Web App scale-out)
- ✅ Auto-scaling rules (CPU, memory-based)
- ✅ Load balancing across instances
- ✅ Stateless API design
- ✅ Background job processing (Hangfire)
- ✅ Queue-based architecture for async tasks
- ✅ Database read replicas (for future growth)
- ✅ Blob storage for media (offload from database)

#### Monitoring
- ✅ Application Insights integration
- ✅ Real-time performance metrics
- ✅ Exception logging and alerting
- ✅ Dependency tracking (database, external APIs)
- ✅ Custom event tracking (business metrics)
- ✅ User session tracking
- ✅ Live metrics stream
- ✅ Alerting rules (error rate, slow requests)
- ✅ PagerDuty integration for critical alerts

---

### 23. Marketing & Growth

#### Marketing Automation (MailChimp)
- ✅ User segmentation (landlords, tenants, active, inactive)
- ✅ Email campaigns for feature announcements
- ✅ Drip campaigns for onboarding
- ✅ Re-engagement campaigns
- ✅ Event tracking sync (user actions → MailChimp)
- ✅ Behavioral email triggers
- ✅ A/B testing for campaigns
- ✅ Campaign performance analytics

#### User Events Tracking
- ✅ LandlordEventRecord for milestone tracking
- ✅ Events tracked:
  - Created property
  - Advertised property (free/paid)
  - Submitted verification (basic/ACH)
  - Approved verification
  - Received application
  - Has tenant
  - Used credit screening
  - Tenants have insurance
  - Generated revenue (screening, ACH, insurance)
- ✅ Sync events to MailChimp for segmentation
- ✅ Event-based email triggers

#### Referral Program (Infrastructure Ready)
- ✅ Unique referral codes per user
- ✅ Referral link generation
- ✅ Track referral source
- ✅ Referral credit/rewards (ready to implement)

#### Analytics & Tracking
- ✅ Google Analytics integration
- ✅ Page view tracking
- ✅ Event tracking (property views, applications, payments)
- ✅ Conversion funnel analysis
- ✅ User flow analysis
- ✅ Custom dimensions (user type, property type)

---

### 24. Mobile Experience

#### Responsive Design
- ✅ Mobile-first responsive layout
- ✅ Touch-optimized UI
- ✅ Mobile navigation menu
- ✅ Swipe gestures for photo galleries
- ✅ Mobile-optimized forms
- ✅ Click-to-call phone numbers
- ✅ Mobile-optimized maps
- ✅ Fast mobile performance (<3s load time)

#### Progressive Web App (PWA) Features (Infrastructure Ready)
- ✅ Service worker for offline caching (ready to implement)
- ✅ Add to home screen prompt (ready to implement)
- ✅ Push notifications (infrastructure ready via SignalR)

---

### 25. Integrations & Webhooks

#### Webhook Support
- ✅ ProfitStars webhook for payment status
- ✅ TransUnion SmartMove webhook for screening completion
- ✅ TransUnion ShareAble webhook for enrollment status
- ✅ SureApp webhook for insurance policy updates
- ✅ Telnyx webhook for inbound SMS
- ✅ SendGrid webhook for email events (delivery, open, click, bounce)
- ✅ Webhook signature verification
- ✅ Webhook retry logic
- ✅ Webhook event logging

#### External Integrations
- ✅ Google Maps / Places API (geolocation, autocomplete)
- ✅ Plaid (bank account verification - optional)
- ✅ Braintree (credit card processing)
- ✅ ProfitStars (ACH processing)
- ✅ TransUnion SmartMove (credit/background checks)
- ✅ TransUnion ShareAble (credit reporting)
- ✅ SendGrid (email delivery)
- ✅ Telnyx (SMS messaging)
- ✅ MailChimp (marketing automation)
- ✅ SureApp (renters insurance)
- ✅ Zillow (listing syndication)
- ✅ HotPads (listing syndication)
- ✅ Azure Blob Storage (file storage)
- ✅ Azure Application Insights (monitoring)

---

### 26. Additional Features

#### Short Links (RentMe.Web.ShortLinksApp)
- ✅ Generate short URLs for properties
- ✅ Redirect to full property page
- ✅ Track link clicks
- ✅ Custom branded short domain

#### Blog/CMS (RentMe.Web.BlogApi)
- ✅ Blog post creation and management
- ✅ SEO-optimized blog URLs
- ✅ Categories and tags
- ✅ Author attribution
- ✅ Related posts
- ✅ Comment system (ready to implement)

#### Localization (Infrastructure Ready)
- ✅ Multi-language support infrastructure
- ✅ Resource files for translations
- ✅ Culture-specific formatting (dates, currency)
- ✅ Ready to add Spanish, French, etc.

#### Accessibility
- ✅ WCAG 2.0 AA compliance (partial)
- ✅ Keyboard navigation support
- ✅ Screen reader compatibility
- ✅ Alt text for images
- ✅ ARIA labels for interactive elements
- ✅ Color contrast compliance
- ✅ Focus indicators

---

## Feature Summary by User Type

### Landlord Features (80+ Features)
Property management, listing syndication, application review, credit checks, lease management, rent collection, billing automation, payment processing, maintenance management, lead management, company management, reporting & analytics, document management, communication tools

### Tenant Features (50+ Features)
Property search, rental applications, credit building, rent payment, auto-pay, payment methods, maintenance requests, lease documents, insurance management, communication with landlord, payment history, notifications

### Admin Features (30+ Features)
User management, property moderation, transaction oversight, system configuration, reporting, support tools, system monitoring, audit logs

---

## Total Feature Count: 350+ Implemented Features

This comprehensive feature set makes RentMe a full-featured property rental management platform suitable for individual landlords, property management companies, and tenants.

---

## Database Schema (Complete ERD)

This section provides a complete database schema with all tables, columns, data types, and relationships.

### Schema Overview

**Total Entities:** 55 tables
**Database:** Microsoft SQL Server
**ORM:** Entity Framework 6 (Code-First)
**Soft Deletes:** Many entities implement `ISoftDeletable` with `IsDeleted` flag

### Complete Table Definitions

#### **ApplicationUsers** (ASP.NET Identity)
```sql
CREATE TABLE ApplicationUsers (
    Id NVARCHAR(128) PRIMARY KEY,
    Email NVARCHAR(256) NOT NULL UNIQUE,
    EmailConfirmed BIT NOT NULL,
    PasswordHash NVARCHAR(MAX),
    SecurityStamp NVARCHAR(MAX),
    PhoneNumber NVARCHAR(50),
    PhoneNumberConfirmed BIT NOT NULL,
    TwoFactorEnabled BIT NOT NULL,
    LockoutEndDateUtc DATETIME,
    LockoutEnabled BIT NOT NULL,
    AccessFailedCount INT NOT NULL,
    UserName NVARCHAR(256) NOT NULL UNIQUE,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    DateCreated DATETIME NOT NULL,
    UserType INT NOT NULL, -- 0=Tenant, 1=Landlord, 2=Admin
    ProfilePhotoUri NVARCHAR(500),
    Bio NVARCHAR(MAX),
    IsApproved BIT NOT NULL DEFAULT 0
);
```

#### **Properties**
```sql
CREATE TABLE Properties (
    Id INT PRIMARY KEY IDENTITY(1,1),
    TuPropertyId INT NULL,
    SaTuPropertyId INT NULL,
    Name NVARCHAR(200),
    Address NVARCHAR(200) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    State INT NOT NULL, -- StateType enum
    Zip NVARCHAR(10) NOT NULL,
    UnitNumber NVARCHAR(50),
    PropertyHighlights NVARCHAR(MAX),
    LocationDetails NVARCHAR(MAX),
    PropertyDetails NVARCHAR(MAX),
    SellerInformation NVARCHAR(MAX),
    Bathrooms FLOAT NOT NULL DEFAULT 0,
    Bedrooms FLOAT NOT NULL DEFAULT 0,
    SquareFootage FLOAT NOT NULL DEFAULT 0,
    IsPropertyVisibleORM BIT NOT NULL DEFAULT 0,
    IsPropertyActive BIT NOT NULL DEFAULT 0,
    SyndicateToZillow BIT NOT NULL DEFAULT 0,
    IsPropertyRented BIT NOT NULL DEFAULT 0,
    CompanyId INT NULL,
    OwnerId NVARCHAR(128) NOT NULL,
    BackgroundCheckFee DECIMAL(18,2) NOT NULL DEFAULT 0,
    EnableBackgroundCheck BIT NOT NULL DEFAULT 0,
    Classification INT NOT NULL DEFAULT 0, -- ClassificationType enum
    DeclineForOpenBankruptcies BIT NOT NULL DEFAULT 0,
    IncludeForeclosures BIT NOT NULL DEFAULT 0,
    IncludeMedicalCollections BIT NOT NULL DEFAULT 0,
    IR FLOAT NULL,
    OpenBankruptcyWindow INT NULL,
    ProductBundle INT NOT NULL DEFAULT 0, -- ProductBundleType enum
    MinimumCreditScore INT NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CurrentLeasePeriodId INT NULL,
    PropertyGroupId INT NULL,
    DateCreated DATETIME NOT NULL,
    LastUpdated DATETIME NOT NULL,
    DateAdvertised DATETIME NULL,
    DateAdvertisedPaidNetworks DATETIME NULL,
    HideStreetAddress BIT NOT NULL DEFAULT 0,
    IsFurnished BIT NOT NULL DEFAULT 0,
    SmokingAllowed BIT NOT NULL DEFAULT 0,
    MerchantLocationId INT NULL,
    SystemTransactionFee DECIMAL(18,2) NULL,
    IsRoomForRent BIT NOT NULL DEFAULT 0,
    LegalOwnerName NVARCHAR(200),
    FOREIGN KEY (CompanyId) REFERENCES LandlordCompanies(Id),
    FOREIGN KEY (OwnerId) REFERENCES ApplicationUsers(Id),
    FOREIGN KEY (CurrentLeasePeriodId) REFERENCES LeasePeriods(Id),
    FOREIGN KEY (PropertyGroupId) REFERENCES PropertyGroups(Id),
    FOREIGN KEY (MerchantLocationId) REFERENCES MerchantLocations(Id)
);
```

#### **PropertyPhotos**
```sql
CREATE TABLE PropertyPhotos (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PropertyId INT NOT NULL,
    PhotoUri NVARCHAR(500) NOT NULL,
    GalleryIndex INT NOT NULL DEFAULT 0,
    IsPrimaryPhoto BIT NOT NULL DEFAULT 0,
    DateCreated DATETIME NOT NULL,
    FOREIGN KEY (PropertyId) REFERENCES Properties(Id) ON DELETE CASCADE
);
```

#### **PropertyListingTags**
```sql
CREATE TABLE PropertyListingTags (
    PropertyId INT NOT NULL,
    ListingTagType INT NOT NULL, -- ListingTagType enum (amenities)
    Value BIGINT NOT NULL,
    PRIMARY KEY (PropertyId, ListingTagType),
    FOREIGN KEY (PropertyId) REFERENCES Properties(Id) ON DELETE CASCADE
);
```

#### **PropertyGroups**
```sql
CREATE TABLE PropertyGroups (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(200) NOT NULL,
    OwnerId NVARCHAR(128) NOT NULL,
    CompanyId INT NULL,
    DateCreated DATETIME NOT NULL,
    FOREIGN KEY (OwnerId) REFERENCES ApplicationUsers(Id),
    FOREIGN KEY (CompanyId) REFERENCES LandlordCompanies(Id)
);
```

#### **PropertyNotes**
```sql
CREATE TABLE PropertyNotes (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PropertyId INT NOT NULL,
    ElectricalService NVARCHAR(200),
    FurnaceFilterSize NVARCHAR(100),
    Note NVARCHAR(MAX),
    YearBuilt INT NOT NULL DEFAULT 0,
    YearAcquired INT NOT NULL DEFAULT 0,
    PurchasePrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    DateCreated DATETIME NOT NULL,
    DateUpdated DATETIME NOT NULL,
    FOREIGN KEY (PropertyId) REFERENCES Properties(Id) ON DELETE CASCADE
);
```

#### **PropertyNoteAppliances**
```sql
CREATE TABLE PropertyNoteAppliances (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PropertyNoteId INT NOT NULL,
    ApplianceName NVARCHAR(200) NOT NULL,
    Condition NVARCHAR(MAX),
    SerialNumber NVARCHAR(200),
    ModelNumber NVARCHAR(200),
    FOREIGN KEY (PropertyNoteId) REFERENCES PropertyNotes(Id) ON DELETE CASCADE
);
```

#### **LeasePeriods**
```sql
CREATE TABLE LeasePeriods (
    Id INT PRIMARY KEY IDENTITY(1,1),
    DateAvailable DATETIME NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NULL,
    LeaseName NVARCHAR(200),
    PropertyId INT NOT NULL,
    LeaseDetails NVARCHAR(MAX),
    LeaseType INT NOT NULL, -- LeaseTypeEnum: Fixed, MonthToMonth, Bidding
    MinimumPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    RentItNowPrice DECIMAL(18,2) NULL,
    Deposit DECIMAL(18,2) NOT NULL DEFAULT 0,
    Rent DECIMAL(18,2) NOT NULL DEFAULT 0,
    IsDeleted BIT NOT NULL DEFAULT 0,
    IsRentersInsuranceRequired BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (PropertyId) REFERENCES Properties(Id)
);
```

#### **LeaseTenants**
```sql
CREATE TABLE LeaseTenants (
    Id INT PRIMARY KEY IDENTITY(1,1),
    LeasePeriodId INT NOT NULL,
    TenantId NVARCHAR(128) NOT NULL,
    MoveInDate DATETIME NULL,
    MoveOutDate DATETIME NULL,
    FOREIGN KEY (LeasePeriodId) REFERENCES LeasePeriods(Id),
    FOREIGN KEY (TenantId) REFERENCES ApplicationUsers(Id)
);
```

#### **RentalApplications**
```sql
CREATE TABLE RentalApplications (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(100),
    MiddleName NVARCHAR(100),
    LastName NVARCHAR(100),
    SSN INT NULL,
    DateOfBirth DATETIME NULL,
    MaritalStatus NVARCHAR(50),
    DriverLicenseNo NVARCHAR(50),
    DriverLicenseState NVARCHAR(2),
    Email NVARCHAR(256),
    EmploymentStatus INT NOT NULL, -- EmploymentStatusType enum
    AssetValue DECIMAL(18,2) NULL,
    -- Questionnaire fields
    BeenSued BIT NULL,
    DeclaredBankruptcy BIT NULL,
    Felony BIT NULL,
    BrokenLease BIT NULL,
    SheriffLockout BIT NULL,
    BroughtToCourtPrevLandLord BIT NULL,
    MovedOwingDamageCompensation BIT NULL,
    TotalMoveInAmountAvailable BIT NULL,
    TypedSignature NVARCHAR(200),
    HasCosignerIfNeeded BIT NULL,
    BackgroundCheckComments NVARCHAR(MAX),
    BackgroundCheckAuthDate DATETIME NOT NULL,
    LinkedInUsername NVARCHAR(100),
    FacebookUsername NVARCHAR(100),
    InstagramUsername NVARCHAR(100),
    TwitterUsername NVARCHAR(100),
    AdditionalNotes NVARCHAR(MAX),
    User_Id NVARCHAR(128),
    DateSubmitted DATETIME NOT NULL,
    DateSubmittedToTu DATETIME NULL,
    CanRunCreditAndBackgroundCheck BIT NOT NULL DEFAULT 0,
    SaTuRenterId INT NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (User_Id) REFERENCES ApplicationUsers(Id)
);
```

#### **PhoneNumbers**
```sql
CREATE TABLE PhoneNumbers (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Number NVARCHAR(20) NOT NULL,
    PhoneType INT NULL, -- PhoneTypeEnum
    Extension NVARCHAR(10),
    RentalApplicationId INT NOT NULL,
    PersonalContactOfRenterId INT NULL,
    FOREIGN KEY (RentalApplicationId) REFERENCES RentalApplications(Id),
    FOREIGN KEY (PersonalContactOfRenterId) REFERENCES PersonalContactOfRenters(Id)
);
```

#### **RentalAddresses**
```sql
CREATE TABLE RentalAddresses (
    Id INT PRIMARY KEY IDENTITY(1,1),
    StreetAddress NVARCHAR(200),
    StreetAddressLineTwo NVARCHAR(200),
    City NVARCHAR(100),
    State NVARCHAR(2),
    Zip NVARCHAR(10),
    YearsAtLocation FLOAT NULL,
    IsCurrentLocation BIT NULL,
    LandlordName NVARCHAR(200),
    LandlordPhone NVARCHAR(20),
    ReasonForLeaving NVARCHAR(MAX),
    AmountOfRent DECIMAL(18,2) NULL,
    RentPaymentUpToDate BIT NULL,
    RentalApplicationId INT NOT NULL,
    FOREIGN KEY (RentalApplicationId) REFERENCES RentalApplications(Id) ON DELETE CASCADE
);
```

#### **EmploymentRecords**
```sql
CREATE TABLE EmploymentRecords (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Employer NVARCHAR(200),
    Occupation NVARCHAR(200),
    HoursPerWeek INT NULL,
    Supervisor NVARCHAR(200),
    Phone NVARCHAR(20),
    PhoneExt NVARCHAR(10),
    YearsEmployed INT NULL,
    StreetAddress NVARCHAR(200),
    City NVARCHAR(100),
    State NVARCHAR(2),
    Zip NVARCHAR(10),
    Earnings INT NULL,
    EarningsPeriod INT NULL, -- EarningsPeriodType enum
    ActiveEmployment BIT NULL,
    StartDate DATETIME NULL,
    EndDate DATETIME NULL,
    RentalApplicationId INT NOT NULL,
    FOREIGN KEY (RentalApplicationId) REFERENCES RentalApplications(Id) ON DELETE CASCADE
);
```

#### **Incomes**
```sql
CREATE TABLE Incomes (
    Id INT PRIMARY KEY IDENTITY(1,1),
    IncomeAmount DECIMAL(18,2) NULL,
    Source NVARCHAR(200),
    ProofOfIncome NVARCHAR(500),
    IncomePeriod INT NOT NULL, -- EarningsPeriodType enum
    RentalApplicationId INT NOT NULL,
    FOREIGN KEY (RentalApplicationId) REFERENCES RentalApplications(Id) ON DELETE CASCADE
);
```

#### **Pets**
```sql
CREATE TABLE Pets (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    TypeBreed NVARCHAR(200),
    IsIndoorPet BIT NULL,
    Age INT NULL,
    RentalApplicationId INT NOT NULL,
    FOREIGN KEY (RentalApplicationId) REFERENCES RentalApplications(Id) ON DELETE CASCADE
);
```

#### **Vehicles**
```sql
CREATE TABLE Vehicles (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Year INT NULL,
    Make NVARCHAR(100),
    Model NVARCHAR(100),
    Color NVARCHAR(50),
    PlateNo NVARCHAR(20),
    State NVARCHAR(2),
    RentalApplicationId INT NOT NULL,
    FOREIGN KEY (RentalApplicationId) REFERENCES RentalApplications(Id) ON DELETE CASCADE
);
```

#### **PersonalContactOfRenters**
```sql
CREATE TABLE PersonalContactOfRenters (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Relation NVARCHAR(100),
    StreetAddress NVARCHAR(200),
    City NVARCHAR(100),
    State NVARCHAR(2),
    Zip NVARCHAR(10)
);
```

#### **ApplicationGroups**
```sql
CREATE TABLE ApplicationGroups (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PropertyId INT NOT NULL,
    LeasePeriodId INT NOT NULL,
    DateCreated DATETIME NOT NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (PropertyId) REFERENCES Properties(Id),
    FOREIGN KEY (LeasePeriodId) REFERENCES LeasePeriods(Id)
);
```

#### **ApplicationGroupMembers**
```sql
CREATE TABLE ApplicationGroupMembers (
    Id INT PRIMARY KEY IDENTITY(1,1),
    ApplicationGroupId INT NOT NULL,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Relation NVARCHAR(100),
    Age INT NOT NULL,
    Occupation NVARCHAR(200),
    Email NVARCHAR(256),
    UserId NVARCHAR(128),
    ApplicationId INT NULL,
    AcceptedInvitation BIT NOT NULL DEFAULT 0,
    DateAcceptedInvitation DATETIME NULL,
    InvitationsSent INT NOT NULL DEFAULT 0,
    TimeLastInvitationSent DATETIME NULL,
    PropertyBidAuthorizationId INT NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (ApplicationGroupId) REFERENCES ApplicationGroups(Id),
    FOREIGN KEY (UserId) REFERENCES ApplicationUsers(Id),
    FOREIGN KEY (ApplicationId) REFERENCES RentalApplications(Id),
    FOREIGN KEY (PropertyBidAuthorizationId) REFERENCES PropertyBidAuthorizations(Id)
);
```

#### **ApplicationReviews**
```sql
CREATE TABLE ApplicationReviews (
    ApplicationId INT NOT NULL,
    ReviewerId NVARCHAR(128),
    ReviewerCompanyId INT NOT NULL,
    ReviewDate DATETIME NULL,
    ApplicationReviewType INT NOT NULL, -- ApplicationReviewType enum
    ApplicationReviewNotes NVARCHAR(MAX),
    IsDeleted BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (ApplicationId, ReviewerCompanyId),
    FOREIGN KEY (ApplicationId) REFERENCES RentalApplications(Id),
    FOREIGN KEY (ReviewerId) REFERENCES ApplicationUsers(Id)
);
```

#### **PropertyBidAuthorizations** (Background Check Results)
```sql
CREATE TABLE PropertyBidAuthorizations (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PropertyId INT NOT NULL,
    PrimaryRenterId NVARCHAR(128) NOT NULL,
    PrimaryApplicationId INT NOT NULL,
    TuApplicationId INT NULL,
    SaTuScreeningRequestRenterId INT NULL,
    SaTuScreeningRequestId INT NULL,
    TuVerificationStatus INT NULL, -- IdmaVerificationStatusType enum
    TuVerificationStatusDate DATETIME NULL,
    TuApplicationStatus INT NULL, -- RequestStatusType enum
    TuReportGenerationRequestDate DATETIME NULL,
    SaTuReportLastUpdatedByTuDate DATETIME NULL,
    DateSubmitted DATETIME NOT NULL,
    ProductBundle INT NULL, -- ProductBundleType enum
    CreditScoreRange INT NULL, -- CreditScoreRangeType enum
    BackgroundCheckClear BIT NULL,
    EvictionCheckClear BIT NULL,
    DateTuReportLastRetrieved DATETIME NULL,
    LeasePeriodId INT NULL,
    ApplicationGroupId INT NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (PropertyId) REFERENCES Properties(Id),
    FOREIGN KEY (PrimaryRenterId) REFERENCES ApplicationUsers(Id),
    FOREIGN KEY (PrimaryApplicationId) REFERENCES RentalApplications(Id),
    FOREIGN KEY (LeasePeriodId) REFERENCES LeasePeriods(Id),
    FOREIGN KEY (ApplicationGroupId) REFERENCES ApplicationGroups(Id)
);
```

#### **Bids**
```sql
CREATE TABLE Bids (
    Id INT PRIMARY KEY IDENTITY(1,1),
    LeasePeriodId INT NOT NULL,
    BidderId NVARCHAR(128) NOT NULL,
    BidAmount DECIMAL(18,2) NOT NULL,
    BidDate DATETIME NOT NULL,
    BidStatus INT NOT NULL, -- BidStatus enum
    IsAutomaticBid BIT NOT NULL DEFAULT 0,
    MaxBidAmount DECIMAL(18,2) NULL,
    FOREIGN KEY (LeasePeriodId) REFERENCES LeasePeriods(Id),
    FOREIGN KEY (BidderId) REFERENCES ApplicationUsers(Id)
);
```

#### **AutoBillings**
```sql
CREATE TABLE AutoBillings (
    Id INT PRIMARY KEY IDENTITY(1,1),
    LeasePeriodId INT NOT NULL,
    BillingCategory INT NOT NULL, -- BillingCategoryType enum
    Amount DECIMAL(18,2) NULL,
    Description NVARCHAR(500),
    DayOfMonthDue INT NOT NULL,
    LateFeesEnabled BIT NOT NULL DEFAULT 0,
    DaysLateAssessFee INT NULL,
    LateFeeAmount DECIMAL(18,2) NULL,
    AutoBillingStatus INT NOT NULL, -- AutoBillingStatusType enum
    FrequencyInMonths INT NOT NULL DEFAULT 1,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NULL,
    CreateNextBillingDate DATETIME NOT NULL,
    DateCreated DATETIME NOT NULL,
    DateUpdated DATETIME NOT NULL,
    IpCreatedFrom NVARCHAR(50),
    LastModifiedById NVARCHAR(128),
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (LeasePeriodId) REFERENCES LeasePeriods(Id),
    FOREIGN KEY (LastModifiedById) REFERENCES ApplicationUsers(Id)
);
```

#### **Billings**
```sql
CREATE TABLE Billings (
    Id INT PRIMARY KEY IDENTITY(1,1),
    AutoBillingId INT NULL,
    LeasePeriodId INT NOT NULL,
    DateCreated DATETIME NOT NULL,
    DateUpdated DATETIME NOT NULL,
    IpCreatedFrom NVARCHAR(50),
    CreatedBySystem BIT NOT NULL DEFAULT 0,
    LastModifiedById NVARCHAR(128),
    BillingCategory INT NOT NULL, -- BillingCategoryType enum
    Description NVARCHAR(500),
    Amount DECIMAL(18,2) NULL,
    DueDate DATETIME NOT NULL,
    ServicePeriodStart DATETIME NULL,
    ServicePeriodEnd DATETIME NULL,
    LateFeesEnabled BIT NOT NULL DEFAULT 0,
    LateFeeAmount DECIMAL(18,2) NULL,
    DaysLateAssessFee INT NULL,
    LateAfterDate DATETIME NULL,
    IsLate BIT NOT NULL DEFAULT 0,
    FullCorrectedAmount DECIMAL(18,2) NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (AutoBillingId) REFERENCES AutoBillings(Id),
    FOREIGN KEY (LeasePeriodId) REFERENCES LeasePeriods(Id),
    FOREIGN KEY (LastModifiedById) REFERENCES ApplicationUsers(Id)
);
```

#### **BillingReferences**
```sql
CREATE TABLE BillingReferences (
    ReferenceId INT PRIMARY KEY IDENTITY(1,1),
    ParentBillingId INT NOT NULL,
    BillingReferenceType INT NOT NULL, -- BillingReferenceTypeEnum
    ChildBillingId INT NOT NULL,
    UNIQUE (ParentBillingId, ChildBillingId),
    FOREIGN KEY (ParentBillingId) REFERENCES Billings(Id),
    FOREIGN KEY (ChildBillingId) REFERENCES Billings(Id)
);
```

#### **BillingPayments**
```sql
CREATE TABLE BillingPayments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    TransactionId UNIQUEIDENTIFIER NOT NULL UNIQUE DEFAULT NEWID(),
    LeasePeriodId INT NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    PaymentEffectiveDate DATETIME NOT NULL,
    DateCreated DATETIME NOT NULL,
    LastUpdated DATETIME NOT NULL,
    PsBatchId BIGINT NULL,
    IsTransactionSystemFee BIT NOT NULL DEFAULT 0,
    SystemFeeForBillingPaymentId INT NULL,
    IpCreatedFrom NVARCHAR(50),
    CreatedBySystem BIT NOT NULL DEFAULT 0,
    PaidByUserId NVARCHAR(128),
    AuthorizedAsRecurring BIT NOT NULL DEFAULT 0,
    AutoBillingPaymentId INT NULL,
    -- ProfitStars fields
    PsEntityId INT NOT NULL,
    PsLocationId INT NOT NULL,
    PsAccountReferenceId NVARCHAR(100),
    PsResponseCode INT NULL,
    PsResponseMessage NVARCHAR(500),
    PsTransactionReferenceId NVARCHAR(100),
    PsTransactionStatus INT NULL, -- PsTransactionStatusType enum
    PsSettlementStatus INT NULL, -- PsSettlementStatusType enum
    PsEffectiveDate DATETIME NULL,
    FundsAreScheduledOrSettled BIT NOT NULL DEFAULT 0,
    PaymentFailure BIT NOT NULL DEFAULT 0,
    PaymentFailureReason INT NULL, -- PaymentFailureReasonTypes enum
    FOREIGN KEY (LeasePeriodId) REFERENCES LeasePeriods(Id),
    FOREIGN KEY (SystemFeeForBillingPaymentId) REFERENCES BillingPayments(Id),
    FOREIGN KEY (PaidByUserId) REFERENCES ApplicationUsers(Id),
    FOREIGN KEY (AutoBillingPaymentId) REFERENCES AutoBillingPayments(Id),
    FOREIGN KEY (PsBatchId) REFERENCES PsBatches(BatchId)
);
```

#### **BillingPaymentHistories**
```sql
CREATE TABLE BillingPaymentHistories (
    Id INT PRIMARY KEY IDENTITY(1,1),
    BillingPaymentId INT NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    PaymentEffectiveDate DATETIME NOT NULL,
    DateHistoryCreated DATETIME NOT NULL,
    PsEntityId INT NOT NULL,
    PsLocationId INT NOT NULL,
    PsAccountReferenceId NVARCHAR(100),
    PsResponseCode INT NULL,
    PsResponseMessage NVARCHAR(500),
    PsTransactionReferenceId NVARCHAR(100),
    PsTransactionStatus INT NULL,
    PsSettlementStatus INT NULL,
    PsEffectiveDate DATETIME NULL,
    FundsAreScheduledOrSettled BIT NOT NULL DEFAULT 0,
    PaymentFailure BIT NOT NULL DEFAULT 0,
    PaymentFailureReason INT NULL,
    FOREIGN KEY (BillingPaymentId) REFERENCES BillingPayments(Id) ON DELETE CASCADE
);
```

#### **BillingPaymentNsfCharges**
```sql
CREATE TABLE BillingPaymentNsfCharges (
    BillingPaymentThatNSFdId INT PRIMARY KEY,
    BillingPaymentNSFChargeId INT NOT NULL,
    FOREIGN KEY (BillingPaymentThatNSFdId) REFERENCES BillingPayments(Id),
    FOREIGN KEY (BillingPaymentNSFChargeId) REFERENCES BillingPayments(Id)
);
```

#### **AutoBillingPayments**
```sql
CREATE TABLE AutoBillingPayments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    LeasePeriodId INT NOT NULL,
    BillingCategory INT NULL, -- BillingCategoryType enum
    SplitType INT NOT NULL, -- SplitTypeEnum: Amount or Percentage
    Amount DECIMAL(18,2) NOT NULL,
    PayOnDayOfMonth INT NULL,
    FrequencyInMonths INT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NULL,
    DateCreated DATETIME NOT NULL,
    NextTransmitDate DATETIME NOT NULL,
    NextEffectiveDate DATETIME NULL,
    IsEnabled BIT NOT NULL DEFAULT 1,
    IpCreatedFrom NVARCHAR(50),
    CreatedByUserId NVARCHAR(128),
    DateDeleted DATETIME NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (LeasePeriodId) REFERENCES LeasePeriods(Id),
    FOREIGN KEY (CreatedByUserId) REFERENCES ApplicationUsers(Id)
);
```

#### **CustomerAccounts** (ProfitStars Bank Accounts)
```sql
CREATE TABLE CustomerAccounts (
    UserId NVARCHAR(128) NOT NULL,
    EntityId INT NOT NULL,
    PsCustomerRegistered BIT NOT NULL DEFAULT 0,
    CustomerNumber NVARCHAR(100),
    BankInfoSet BIT NOT NULL DEFAULT 0,
    PsAccountRegistered BIT NOT NULL DEFAULT 0,
    AccountReferenceId NVARCHAR(100),
    AccountName NVARCHAR(200),
    IsRentMeCustomerAccount BIT NOT NULL DEFAULT 0,
    IsDeleted BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (UserId, EntityId),
    FOREIGN KEY (UserId) REFERENCES ApplicationUsers(Id)
);
```

#### **MerchantLocations** (ProfitStars Merchant Accounts)
```sql
CREATE TABLE MerchantLocations (
    Id INT PRIMARY KEY IDENTITY(1,1),
    LocationId INT NOT NULL,
    EntityId INT NOT NULL,
    CompanyId INT NOT NULL,
    LocationName NVARCHAR(200),
    DefaultMerchantTransactionFee DECIMAL(18,2) NULL,
    IsEnabled BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (CompanyId) REFERENCES LandlordCompanies(Id)
);
```

#### **PsBatches** (ProfitStars Payment Batches)
```sql
CREATE TABLE PsBatches (
    BatchId BIGINT PRIMARY KEY, -- NOT IDENTITY, comes from ProfitStars
    BatchStatus NVARCHAR(50),
    EffectiveDate DATETIME NOT NULL,
    Description NVARCHAR(500),
    Amount DECIMAL(18,2) NOT NULL,
    EntityId INT NOT NULL,
    CompanyId INT NULL,
    FOREIGN KEY (CompanyId) REFERENCES LandlordCompanies(Id)
);
```

#### **PsBatchTransactions**
```sql
CREATE TABLE PsBatchTransactions (
    Id INT PRIMARY KEY IDENTITY(1,1),
    BatchId BIGINT NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    BatchDescription NVARCHAR(500),
    EntryType NVARCHAR(50),
    DisplayAccountNumber NVARCHAR(50),
    AccountType NVARCHAR(50),
    PsTransactionStatus INT NULL,
    PsSettlementStatus INT NULL,
    TransactionNumber NVARCHAR(100),
    PsReferenceNumber NVARCHAR(100),
    EffectiveDate DATETIME NOT NULL,
    CustomerNumber NVARCHAR(100),
    CustomerName NVARCHAR(200),
    PropertyAddress NVARCHAR(500),
    PropertyId INT NULL,
    LeasePeriodId INT NULL,
    FOREIGN KEY (BatchId) REFERENCES PsBatches(BatchId),
    FOREIGN KEY (PropertyId) REFERENCES Properties(Id),
    FOREIGN KEY (LeasePeriodId) REFERENCES LeasePeriods(Id)
);
```

#### **PsApplicationEntities** (ProfitStars Landlord Applications)
```sql
CREATE TABLE PsApplicationEntities (
    Id INT PRIMARY KEY IDENTITY(1,1),
    SubmissionResponseMessage NVARCHAR(MAX),
    SubmittedSuccessfully BIT NOT NULL DEFAULT 0,
    LandlordRentAppStatus INT NOT NULL, -- LandlordRentAppStatusType enum
    ApplicationJson NVARCHAR(MAX),
    ModelJson NVARCHAR(MAX),
    SubmittedByUserId NVARCHAR(128),
    SubmittingUsersCompanyId INT NULL,
    DateSubmitted DATETIME NOT NULL,
    IpAddressSubmittedFrom NVARCHAR(50),
    RequiresHigherLimits BIT NOT NULL DEFAULT 0,
    TOSVersion NVARCHAR(50),
    SubmittedToProcessor BIT NOT NULL DEFAULT 0,
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (SubmittedByUserId) REFERENCES ApplicationUsers(Id),
    FOREIGN KEY (SubmittingUsersCompanyId) REFERENCES LandlordCompanies(Id)
);
```

#### **Payments** (Braintree CC Payments - Application Fees)
```sql
CREATE TABLE Payments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Amount DECIMAL(18,2) NOT NULL,
    PaymentReason INT NOT NULL, -- PaymentReasonType enum
    Success BIT NOT NULL DEFAULT 0,
    TransactionStatus NVARCHAR(50),
    StatusMessage NVARCHAR(500),
    BraintreeTransactionId NVARCHAR(100),
    RentalApplicationId INT NULL,
    DateCreated DATETIME NOT NULL,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    StreetAddress NVARCHAR(200),
    Locality NVARCHAR(100),
    Region NVARCHAR(2),
    PostalCode NVARCHAR(10),
    Refunded BIT NOT NULL DEFAULT 0,
    PaidByUserId NVARCHAR(128),
    CreatedFromIp NVARCHAR(50),
    UserAgentInfo NVARCHAR(500),
    FOREIGN KEY (RentalApplicationId) REFERENCES RentalApplications(Id),
    FOREIGN KEY (PaidByUserId) REFERENCES ApplicationUsers(Id)
);
```

#### **CCPaymentMethods** (Table Per Hierarchy - Discriminator column)
```sql
CREATE TABLE CCPaymentMethods (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Discriminator NVARCHAR(128) NOT NULL, -- 'LandlordCCPaymentMethod' or 'RenterCCPaymentMethod'
    CreatedByUserId NVARCHAR(128),
    CompanyId INT NULL, -- Only for Landlord
    DateCreated DATETIME NOT NULL,
    DateUpdated DATETIME NOT NULL,
    ExpirationDate DATETIME NULL,
    BillingFirstName NVARCHAR(100),
    BillingLastName NVARCHAR(100),
    BillingStreetAddress NVARCHAR(200),
    BillingLocality NVARCHAR(100),
    BillingRegion NVARCHAR(2),
    CreatedFromIp NVARCHAR(50),
    UserAgentInfo NVARCHAR(500),
    Success BIT NOT NULL DEFAULT 0,
    BraintreeCustomerId NVARCHAR(100),
    BraintreePrimaryPaymentMethodId NVARCHAR(100),
    StatusMessage NVARCHAR(500),
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (CreatedByUserId) REFERENCES ApplicationUsers(Id),
    FOREIGN KEY (CompanyId) REFERENCES LandlordCompanies(Id)
);
```

#### **ServiceCharges** (Table Per Hierarchy - Base for fees)
```sql
CREATE TABLE ServiceCharges (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Discriminator NVARCHAR(128) NOT NULL, -- 'SyndicationCharge' or 'PremiumServiceCharge'
    CompanyId INT NOT NULL, -- LandlordServiceCharge fields
    Amount DECIMAL(18,2) NOT NULL,
    Description NVARCHAR(500),
    ChargeDate DATETIME NOT NULL,
    -- SyndicationCharge specific
    StartAdvertiseProperty DATETIME NULL,
    EndAdvertiseProperty DATETIME NULL,
    StartChargePeriod DATETIME NULL,
    EndChargePeriod DATETIME NULL,
    PropertyId INT NULL,
    PaymentId INT NULL,
    FOREIGN KEY (CompanyId) REFERENCES LandlordCompanies(Id),
    FOREIGN KEY (PropertyId) REFERENCES Properties(Id),
    FOREIGN KEY (PaymentId) REFERENCES Payments(Id)
);
```

#### **LandlordCompanies**
```sql
CREATE TABLE LandlordCompanies (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CompanyName NVARCHAR(200) NOT NULL,
    OwnerUserId NVARCHAR(128) NOT NULL,
    CompanyType INT NOT NULL, -- CompanyType enum
    TaxId NVARCHAR(50),
    Address NVARCHAR(200),
    City NVARCHAR(100),
    State NVARCHAR(2),
    Zip NVARCHAR(10),
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(256),
    Website NVARCHAR(500),
    LogoUri NVARCHAR(500),
    IsActive BIT NOT NULL DEFAULT 1,
    DateCreated DATETIME NOT NULL,
    AchSetupComplete BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (OwnerUserId) REFERENCES ApplicationUsers(Id)
);
```

#### **LandlordCompanyPermissions**
```sql
CREATE TABLE LandlordCompanyPermissions (
    LandlordCompanyId INT NOT NULL,
    UserId NVARCHAR(128) NOT NULL,
    Permission INT NOT NULL, -- LandlordCompanyPermissionType enum
    IsDeleted BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (LandlordCompanyId, UserId),
    FOREIGN KEY (LandlordCompanyId) REFERENCES LandlordCompanies(Id),
    FOREIGN KEY (UserId) REFERENCES ApplicationUsers(Id)
);
```

#### **Leads**
```sql
CREATE TABLE Leads (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PropertyId INT NOT NULL,
    UserId NVARCHAR(128) NULL,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Email NVARCHAR(256),
    PhoneNumber NVARCHAR(20),
    Message NVARCHAR(MAX),
    PreferredContactMethod INT NULL, -- ContactMethod enum
    ShowingDate DATETIME NULL,
    LeadStatus INT NOT NULL, -- LeadStatus enum
    DateCreated DATETIME NOT NULL,
    Source INT NULL, -- LeadSource enum
    FOREIGN KEY (PropertyId) REFERENCES Properties(Id),
    FOREIGN KEY (UserId) REFERENCES ApplicationUsers(Id)
);
```

#### **MaintenanceRequests**
```sql
CREATE TABLE MaintenanceRequests (
    Id INT PRIMARY KEY IDENTITY(1,1),
    LeasePeriodId INT NOT NULL,
    PropertyId INT NOT NULL,
    TenantId NVARCHAR(128) NOT NULL,
    LandlordId NVARCHAR(128) NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    Priority INT NOT NULL, -- MaintenancePriority enum
    Status INT NOT NULL, -- MaintenanceStatus enum
    Category INT NOT NULL, -- MaintenanceCategory enum
    DateSubmitted DATETIME NOT NULL,
    DateCompleted DATETIME NULL,
    EstimatedCost DECIMAL(18,2) NULL,
    ActualCost DECIMAL(18,2) NULL,
    Notes NVARCHAR(MAX),
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (LeasePeriodId) REFERENCES LeasePeriods(Id),
    FOREIGN KEY (PropertyId) REFERENCES Properties(Id),
    FOREIGN KEY (TenantId) REFERENCES ApplicationUsers(Id),
    FOREIGN KEY (LandlordId) REFERENCES ApplicationUsers(Id)
);
```

#### **MaintenanceRequestPhotos**
```sql
CREATE TABLE MaintenanceRequestPhotos (
    Id INT PRIMARY KEY IDENTITY(1,1),
    MaintenanceRequestId INT NOT NULL,
    PhotoUri NVARCHAR(500) NOT NULL,
    DateUploaded DATETIME NOT NULL,
    UploadedByUserId NVARCHAR(128),
    FOREIGN KEY (MaintenanceRequestId) REFERENCES MaintenanceRequests(Id) ON DELETE CASCADE,
    FOREIGN KEY (UploadedByUserId) REFERENCES ApplicationUsers(Id)
);
```

#### **RentersInsurances**
```sql
CREATE TABLE RentersInsurances (
    Id INT PRIMARY KEY IDENTITY(1,1),
    RentersInsuranceType INT NOT NULL, -- RentersInsuranceTypeEnum
    DatePurchasedSubmitted DATETIME NOT NULL,
    RentersInsuranceDocumentId INT NULL,
    AgreementId NVARCHAR(100),
    SureStatusCode NVARCHAR(50),
    SureStatusDate DATETIME NULL,
    PolicyNumber NVARCHAR(100),
    TotalPremium DECIMAL(18,2) NULL,
    MonthlyPremium DECIMAL(18,2) NULL,
    PaymentFrequency INT NULL, -- RentersInsurancePaymentFrequencyType
    IncludePetDamage BIT NULL,
    IncludeWaterBackup BIT NULL,
    IncludeEarthquake BIT NULL,
    IncludeReplacementCost BIT NULL,
    IncludeIdentityFraud BIT NULL,
    PersonalPropertyCoverage DECIMAL(18,2) NULL,
    AllPerilDeductible DECIMAL(18,2) NULL,
    MedicalLimit DECIMAL(18,2) NULL,
    LiabilityLimit DECIMAL(18,2) NULL,
    HurricaneDeductible DECIMAL(18,2) NULL,
    UserId NVARCHAR(128),
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (RentersInsuranceDocumentId) REFERENCES AccountDocuments(Id),
    FOREIGN KEY (UserId) REFERENCES ApplicationUsers(Id)
);
```

#### **AccountDocuments**
```sql
CREATE TABLE AccountDocuments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UserId NVARCHAR(128) NOT NULL,
    DocumentType INT NOT NULL, -- DocumentType enum
    DocumentUri NVARCHAR(500) NOT NULL,
    UploadDate DATETIME NOT NULL,
    FileName NVARCHAR(200),
    FileSize BIGINT NULL,
    FOREIGN KEY (UserId) REFERENCES ApplicationUsers(Id)
);
```

#### **AccountDocumentRequests**
```sql
CREATE TABLE AccountDocumentRequests (
    Id INT PRIMARY KEY IDENTITY(1,1),
    RequestedByUserId NVARCHAR(128) NOT NULL,
    RequestedFromUserId NVARCHAR(128) NOT NULL,
    DocumentType INT NOT NULL,
    RequestDate DATETIME NOT NULL,
    DueDate DATETIME NULL,
    FulfilledDate DATETIME NULL,
    Status INT NOT NULL, -- DocumentRequestStatus enum
    Notes NVARCHAR(MAX),
    FOREIGN KEY (RequestedByUserId) REFERENCES ApplicationUsers(Id),
    FOREIGN KEY (RequestedFromUserId) REFERENCES ApplicationUsers(Id)
);
```

#### **AccountVerificationHistories**
```sql
CREATE TABLE AccountVerificationHistories (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UserId NVARCHAR(128) NOT NULL,
    VerificationDate DATETIME NOT NULL,
    VerificationType INT NOT NULL, -- VerificationType enum
    Status INT NOT NULL, -- VerificationStatus enum
    Details NVARCHAR(MAX),
    FOREIGN KEY (UserId) REFERENCES ApplicationUsers(Id)
);
```

#### **SentNotifications**
```sql
CREATE TABLE SentNotifications (
    Id INT PRIMARY KEY IDENTITY(1,1),
    NotificationDelivery INT NOT NULL, -- NotificationDeliveryType enum: Email, SMS
    NotificationReason INT NOT NULL, -- NotificationReasonType enum
    UserId NVARCHAR(128),
    LastSentDate DATETIME NOT NULL,
    ExtraData NVARCHAR(MAX),
    FOREIGN KEY (UserId) REFERENCES ApplicationUsers(Id)
);
```

#### **LandlordEventRecords** (Analytics & Marketing)
```sql
CREATE TABLE LandlordEventRecords (
    EventRecordType INT NOT NULL, -- UserEventRecordType enum
    UserId NVARCHAR(128) NOT NULL,
    UserEmail NVARCHAR(256),
    LastLogin DATETIME NOT NULL,
    LastUpdated DATETIME NOT NULL,
    CreatedProperty BIT NOT NULL DEFAULT 0,
    SubmittedBasicVerification BIT NOT NULL DEFAULT 0,
    ApprovedBasicVerification BIT NOT NULL DEFAULT 0,
    SubmittedACHVerification BIT NOT NULL DEFAULT 0,
    ApprovedACHVerification BIT NOT NULL DEFAULT 0,
    AdvertisedPropertyPaid BIT NOT NULL DEFAULT 0,
    AdvertisedPropertyFree BIT NOT NULL DEFAULT 0,
    ReceivedApplication BIT NOT NULL DEFAULT 0,
    HasTenant BIT NOT NULL DEFAULT 0,
    UsedTenantCreditBackgroundScreening BIT NOT NULL DEFAULT 0,
    TenantsUseRentersInsurance BIT NOT NULL DEFAULT 0,
    HasMaintenanceRequest BIT NOT NULL DEFAULT 0,
    GeneratedCreditBackgroundRevenue BIT NOT NULL DEFAULT 0,
    GeneratedACHRevenue BIT NOT NULL DEFAULT 0,
    GeneratedRentersInsuranceRevenue BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (EventRecordType, UserId),
    FOREIGN KEY (UserId) REFERENCES ApplicationUsers(Id)
);
```

#### **PhoneLookupInfos** (Telnyx SMS)
```sql
CREATE TABLE PhoneLookupInfos (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PhoneNumber NVARCHAR(20) NOT NULL UNIQUE,
    CarrierName NVARCHAR(200),
    PhoneNumberType NVARCHAR(50),
    LastLookupDate DATETIME NOT NULL
);
```

#### **SystemLimits**
```sql
CREATE TABLE SystemLimits (
    Id INT PRIMARY KEY IDENTITY(1,1),
    LimitType INT NOT NULL UNIQUE, -- SystemLimitType enum
    MaxValue INT NOT NULL,
    ResetPeriod INT NOT NULL, -- ResetPeriodType enum: Daily, Monthly, Yearly
    Description NVARCHAR(500)
);
```

#### **SystemLimitTallies**
```sql
CREATE TABLE SystemLimitTallies (
    Id INT PRIMARY KEY IDENTITY(1,1),
    SystemLimitId INT NOT NULL,
    UserId NVARCHAR(128) NULL,
    CompanyId INT NULL,
    CurrentValue INT NOT NULL DEFAULT 0,
    LastResetDate DATETIME NOT NULL,
    FOREIGN KEY (SystemLimitId) REFERENCES SystemLimits(Id),
    FOREIGN KEY (UserId) REFERENCES ApplicationUsers(Id),
    FOREIGN KEY (CompanyId) REFERENCES LandlordCompanies(Id)
);
```

### Entity Relationship Diagram (ERD)

```
┌────────────────────┐
│ ApplicationUsers   │
│ (ASP.NET Identity) │
└─────────┬──────────┘
          │
          ├─────────────────────────────────────────────────────────┐
          │                                                         │
          ▼                                                         ▼
┌───────────────────┐                                    ┌──────────────────┐
│ LandlordCompanies │◄───────────┐                      │ RentalApplications│
└─────────┬─────────┘            │                      └─────────┬─────────┘
          │                      │                                │
          ▼                      │                                ├──►PhoneNumbers
┌────────────────────┐           │                                ├──►RentalAddresses
│LandlordCompany     │           │                                ├──►EmploymentRecords
│Permissions         │           │                                ├──►Incomes
└────────────────────┘           │                                ├──►Pets
                                 │                                └──►Vehicles
┌─────────────────┐              │
│  Properties     │──────────────┘
└────────┬────────┘
         │
         ├──►PropertyPhotos
         ├──►PropertyListingTags
         ├──►PropertyNotes ──►PropertyNoteAppliances
         ├──►PropertyGroups
         │
         ▼
┌─────────────────┐
│  LeasePeriods   │
└────────┬────────┘
         │
         ├──►LeaseTenants
         ├──►Bids
         │
         ├──►AutoBillings ──►Billings ◄──►BillingReferences
         │                        │
         │                        ▼
         ├──►AutoBillingPayments  BillingPayments
         │                        │
         └──►BillingPayments ◄────┘
                    │
                    ├──►BillingPaymentHistories
                    ├──►BillingPaymentNsfCharges
                    └──►PsBatches ──►PsBatchTransactions

┌──────────────────────┐
│ ApplicationGroups    │──►ApplicationGroupMembers
└──────────────────────┘

┌──────────────────────┐
│PropertyBidAuth       │  (Background checks)
│(SmartMove Results)   │
└──────────────────────┘

┌──────────────────────┐
│ CustomerAccounts     │  (ProfitStars)
└──────────────────────┘

┌──────────────────────┐
│ MerchantLocations    │  (ProfitStars)
└──────────────────────┘

┌──────────────────────┐
│ PsApplicationEntities│  (ProfitStars Apps)
└──────────────────────┘

┌──────────────────────┐
│ CCPaymentMethods     │  (Braintree)
│ (Table Per Hierarchy)│
├──LandlordCC         │
└──RenterCC           │
└──────────────────────┘

┌──────────────────────┐
│ Payments             │  (Braintree - App Fees)
└──────────────────────┘

┌──────────────────────┐
│ ServiceCharges       │
│ (Table Per Hierarchy)│
├──SyndicationCharge  │
└──PremiumServiceCharge│
└──────────────────────┘

┌──────────────────────┐
│ Leads                │
└──────────────────────┘

┌──────────────────────┐
│ MaintenanceRequests  │──►MaintenanceRequestPhotos
└──────────────────────┘

┌──────────────────────┐
│ RentersInsurances    │
└──────────────────────┘

┌──────────────────────┐
│ AccountDocuments     │
└──────────────────────┘

┌──────────────────────┐
│AccountDocumentRequest│
└──────────────────────┘

┌──────────────────────┐
│AccountVerification   │
│Histories             │
└──────────────────────┘

┌──────────────────────┐
│ SentNotifications    │
└──────────────────────┘

┌──────────────────────┐
│LandlordEventRecords  │  (Analytics)
└──────────────────────┘

┌──────────────────────┐
│ PhoneLookupInfos     │  (Telnyx)
└──────────────────────┘

┌──────────────────────┐
│ SystemLimits         │──►SystemLimitTallies
└──────────────────────┘
```

### Key Relationships Summary

**Core Rental Flow:**
```
ApplicationUser (Landlord) → LandlordCompany → Property → LeasePeriod
                                                  ↓
ApplicationUser (Tenant) → RentalApplication → PropertyBidAuthorization
                                                  ↓
                                              LeasePeriod → LeaseTenant
                                                  ↓
                                              AutoBilling → Billing
                                                  ↓
                                              BillingPayment → PsBatch
```

**Payment Processing:**
```
Tenant → CustomerAccount (Bank) → BillingPayment → PsBatch → MerchantLocation → Landlord
Tenant → CCPaymentMethod (Card) → Payment (App Fee) → Braintree
```

**Background Checks:**
```
RentalApplication → PropertyBidAuthorization → TransUnion SmartMove API
PropertyBidAuthorization stores: CreditScore, BackgroundClear, EvictionClear
```

**Maintenance:**
```
LeaseTenant → MaintenanceRequest → MaintenanceRequestPhoto
                    ↓
          Landlord notification
```

### Database Indexes (Recommended)

**High-Traffic Queries:**
```sql
CREATE INDEX IX_Properties_OwnerId ON Properties(OwnerId);
CREATE INDEX IX_Properties_CompanyId ON Properties(CompanyId);
CREATE INDEX IX_Properties_IsPropertyActive ON Properties(IsPropertyActive) WHERE IsDeleted = 0;
CREATE INDEX IX_Properties_City_State ON Properties(City, State) WHERE IsDeleted = 0;

CREATE INDEX IX_LeasePeriods_PropertyId ON LeasePeriods(PropertyId);
CREATE INDEX IX_LeaseTenants_TenantId ON LeaseTenants(TenantId);
CREATE INDEX IX_LeaseTenants_LeasePeriodId ON LeaseTenants(LeasePeriodId);

CREATE INDEX IX_Billings_LeasePeriodId ON Billings(LeasePeriodId);
CREATE INDEX IX_Billings_DueDate ON Billings(DueDate) WHERE IsDeleted = 0;
CREATE INDEX IX_AutoBillings_LeasePeriodId ON AutoBillings(LeasePeriodId);

CREATE INDEX IX_BillingPayments_LeasePeriodId ON BillingPayments(LeasePeriodId);
CREATE INDEX IX_BillingPayments_PaidByUserId ON BillingPayments(PaidByUserId);
CREATE INDEX IX_BillingPayments_TransactionId ON BillingPayments(TransactionId);

CREATE INDEX IX_MaintenanceRequests_LeasePeriodId ON MaintenanceRequests(LeasePeriodId);
CREATE INDEX IX_MaintenanceRequests_TenantId ON MaintenanceRequests(TenantId);
CREATE INDEX IX_MaintenanceRequests_Status ON MaintenanceRequests(Status) WHERE IsDeleted = 0;

CREATE INDEX IX_Leads_PropertyId ON Leads(PropertyId);
CREATE INDEX IX_Leads_UserId ON Leads(UserId);
```

### Enumerations Reference

**Key Enums in Database:**
- **StateType:** US states (0-50)
- **LeaseTypeEnum:** Fixed=0, MonthToMonth=1, Bidding=2
- **BillingCategoryType:** Rent=0, Utilities=1, Pet=2, Parking=3, Other=4
- **AutoBillingStatusType:** Active=0, Paused=1, Completed=2
- **PaymentFailureReasonTypes:** NSF=0, AccountClosed=1, InvalidRouting=2, etc.
- **MaintenancePriority:** Low=0, Medium=1, High=2, Emergency=3
- **MaintenanceStatus:** Submitted=0, Acknowledged=1, InProgress=2, Completed=3
- **ApplicationReviewType:** Pending=0, Approved=1, Denied=2, Withdrawn=3
- **NotificationDeliveryType:** Email=0, SMS=1, Push=2
- **UserEventRecordType:** Landlord=0, Tenant=1

---

## Domain Model & Database Schema

### Core Entities

#### 1. Property Management

**Property**
```csharp
- Id: int (Primary Key)
- TuPropertyId: int? (TransUnion Property ID)
- SaTuPropertyId: int? (ShareAble TransUnion Property ID)
- Name: string
- Address: string
- City: string
- State: StateType (enum)
- Zip: string
- UnitNumber: string
- PropertyHighlights: string (markdown/HTML)
- LocationDetails: string
- PropertyDetails: string
- Bathrooms: double
- Bedrooms: double
- SquareFootage: double
- IsPropertyVisibleORM: bool (publicly visible on site)
- IsPropertyActive: bool (advertised/syndicated)
- SyndicateToZillow: bool
- IsPropertyRented: bool
- CompanyId: int? (Foreign Key)
- OwnerId: string (ApplicationUser ID)
- BackgroundCheckFee: decimal
- EnableBackgroundCheck: bool
- Classification: ClassificationType (TransUnion)
- DeclineForOpenBankruptcies: bool
- IncludeForeclosures: bool
- IncludeMedicalCollections: bool
- IR: double? (Income Ratio)
- OpenBankruptcyWindow: int?
- ProductBundle: ProductBundleType
- MinimumCreditScore: int?
- IsDeleted: bool (soft delete)
- CurrentLeasePeriodId: int?
- PropertyGroupId: int?
- DateCreated: DateTime
- LastUpdated: DateTime
- DateAdvertised: DateTime? (free networks)
- DateAdvertisedPaidNetworks: DateTime?
- HideStreetAddress: bool
- IsFurnished: bool
- SmokingAllowed: bool
- IsRoomForRent: bool
- LegalOwnerName: string
- MerchantLocationId: int? (ProfitStars)
- SystemTransactionFee: decimal?
```

**PropertyPhoto**
- Id, PropertyId, PhotoUri, GalleryIndex, IsPrimaryPhoto, DateCreated

**PropertyListingTag**
- Id, PropertyId, Tag (amenities, features)

**PropertyNote**
- Property inspection notes, move-in/move-out checklists

**PropertyNoteAppliance**
- Appliance conditions and tracking

**PropertyGroup**
- Grouping properties for portfolio management

#### 2. Lease Management

**LeasePeriod**
```csharp
- Id: int
- DateAvailable: DateTime
- StartDate: DateTime
- EndDate: DateTime?
- LeaseName: string
- PropertyId: int
- LeaseDetails: string
- LeaseType: LeaseTypeEnum (Fixed, MonthToMonth, Bidding)
- MinimumPrice: decimal (for bidding)
- RentItNowPrice: decimal? (buy-it-now price)
- Deposit: decimal
- Rent: decimal
- IsDeleted: bool
- IsRentersInsuranceRequired: bool
```

**LeaseTenant**
- Links tenants to lease periods
- Id, LeasePeriodId, TenantId, MoveInDate, MoveOutDate

#### 3. Tenant Applications

**RentalApplication**
```csharp
- Id, PropertyId, ApplicantId (ApplicationUser)
- ApplicationStatus: enum (Pending, Approved, Denied, Withdrawn)
- DateSubmitted, DateReviewed
- CurrentEmployer, MonthlyIncome, JobTitle
- HasPets, NumberOfOccupants
- MoveInDate
- AdditionalInfo: string
- BackgroundCheckCompleted: bool
- CreditScore: int?
```

**ApplicationGroup**
- Groups multiple applicants applying together
- Id, PropertyId, ApplicationGroupStatus, DateCreated

**ApplicationGroupMember**
- Links RentalApplications to ApplicationGroups

**ApplicationReview**
- Landlord notes and reviews on applications

#### 4. Bidding System

**Bid**
```csharp
- Id, LeasePeriodId, BidderId (ApplicationUser)
- BidAmount: decimal
- BidDate: DateTime
- BidStatus: enum (Active, Accepted, Rejected, Withdrawn)
- IsAutomaticBid: bool
- MaxBidAmount: decimal?
```

**PropertyBidAuthorization**
- Grants users permission to bid on properties
- Id, PropertyId, LeasePeriodId, UserId, DateGranted

#### 5. Billing & Payments

**AutoBilling**
```csharp
- Id, LeasePeriodId, TenantId
- Amount: decimal
- DueDay: int (day of month)
- BillingCategory: enum (Rent, Utilities, Pet, Parking, Other)
- Description: string
- IsActive: bool
- StartDate, EndDate
- LateFeesEnabled: bool
- LateFeeAmount: decimal?
- DaysLateAssessFee: int?
```

**Billing**
```csharp
- Id, AutoBillingId, LeasePeriodId
- DateCreated, DateUpdated
- IpCreatedFrom: string
- CreatedBySystem: bool
- LastModifiedById: string
- BillingCategory: enum
- Description: string
- Amount: decimal
- DueDate: DateTime
- ServicePeriodStart: DateTime?
- ServicePeriodEnd: DateTime?
- LateFeesEnabled: bool
- LateFeeAmount: decimal?
- DaysLateAssessFee: int?
- LateAfterDate: DateTime?
- IsLate: bool
- FullCorrectedAmount: decimal? (for corrections)
- IsDeleted: bool
```

**BillingPayment**
```csharp
- Id, BillingId, LeasePeriodId
- Amount: decimal
- PaymentDate: DateTime
- PaymentMethod: enum (ACH, CreditCard, Cash, Check, Other)
- TransactionId: string
- Status: enum (Pending, Completed, Failed, Refunded)
- ProcessorFee: decimal?
- NetAmount: decimal
- Notes: string
- PsBatchTransactionId: int? (ProfitStars)
```

**BillingPaymentHistory**
- Audit trail for payment changes

**BillingPaymentNsfCharge**
- NSF (Non-Sufficient Funds) fee tracking

**BillingReference**
- Links related billings (corrections, adjustments)

**AutoBillingPayment**
- Scheduled automatic payments

#### 6. Payment Methods

**CCPaymentMethod** (Base class)
- Id, UserId, Token, Last4, ExpirationMonth, ExpirationYear
- CardType, IsDefault, DateAdded, IsDeleted

**LandlordCCPaymentMethod**
- Inherits CCPaymentMethod
- Additional landlord-specific fields

**RenterCCPaymentMethod**
- Inherits CCPaymentMethod
- Additional tenant-specific fields

#### 7. ProfitStars Integration

**CustomerAccount**
```csharp
- Id, UserId (ApplicationUser)
- PsCustomerId: string (ProfitStars Customer ID)
- AccountNumber: string (encrypted)
- RoutingNumber: string
- AccountType: enum (Checking, Savings)
- BankName: string
- IsVerified: bool
- IsActive: bool
```

**MerchantLocation**
- ProfitStars merchant account configuration
- Id, CompanyId, PsMerchantId, AccountName

**PsBatch**
- ProfitStars batch processing records
- Id, PsBatchId, Status, CreatedDate, ProcessedDate

**PsBatchTransaction**
- Individual transactions within batches
- Id, PsBatchId, TransactionType, Amount, Status

**PsApplicationEntity**
- Links ProfitStars applications to internal entities

#### 8. User Management

**ApplicationUser** (ASP.NET Identity)
```csharp
- Id: string (GUID)
- Email: string
- UserName: string
- PhoneNumber: string
- FirstName: string
- LastName: string
- UserType: enum (Landlord, Tenant, Admin)
- DateCreated: DateTime
- IsApproved: bool
- ProfilePhotoUri: string
- Bio: string
- -- ASP.NET Identity fields --
```

**PhoneNumber**
- User phone number management
- Id, UserId, Number, IsPrimary, IsVerified

**PhoneLookupInfo**
- Phone number verification data (Telnyx)

#### 9. Company Management

**LandlordCompany**
```csharp
- Id, OwnerId (ApplicationUser)
- CompanyName: string
- CompanyType: enum (Individual, LLC, Corporation)
- TaxId: string
- Address, City, State, Zip
- PhoneNumber, Email
- Website: string
- LogoUri: string
- IsActive: bool
- DateCreated: DateTime
- AchSetupComplete: bool
- MerchantLocationId: int?
```

**LandlordCompanyPermission**
- User permissions within companies
- Id, CompanyId, UserId, PermissionLevel: enum (Owner, Manager, ReadOnly)

#### 10. Leads & Showings

**Lead**
```csharp
- Id, PropertyId, UserId (prospective tenant)
- FirstName, LastName, Email, PhoneNumber
- Message: string
- PreferredContactMethod: enum
- ShowingDate: DateTime?
- LeadStatus: enum (New, Contacted, Scheduled, Completed, Lost)
- DateCreated: DateTime
- Source: enum (Website, Zillow, HotPads, Referral, Other)
```

#### 11. Maintenance

**MaintenanceRequest**
```csharp
- Id, LeasePeriodId, PropertyId
- TenantId, LandlordId
- Title: string
- Description: string
- Priority: enum (Low, Medium, High, Emergency)
- Status: enum (Submitted, Acknowledged, InProgress, Completed, Cancelled)
- Category: enum (Plumbing, Electrical, HVAC, Appliance, Other)
- DateSubmitted: DateTime
- DateCompleted: DateTime?
- EstimatedCost: decimal?
- ActualCost: decimal?
- Notes: string
- IsDeleted: bool
```

**MaintenanceRequestPhoto**
- Photos attached to maintenance requests

#### 12. Insurance

**RentersInsurance**
```csharp
- Id, TenantId, LeasePeriodId
- Provider: string (SureApp)
- PolicyNumber: string
- CoverageAmount: decimal
- StartDate: DateTime
- EndDate: DateTime
- Status: enum (Active, Expired, Cancelled)
- MonthlyPremium: decimal
- VerificationDocumentUri: string
```

#### 13. Documents

**AccountDocument**
- User document storage (W-9, IDs, etc.)
- Id, UserId, DocumentType, DocumentUri, UploadDate

**AccountDocumentRequest**
- Document requests from landlord to tenant

#### 14. Charges & Fees

**ServiceCharge**
- One-time or recurring service charges
- Id, Amount, Description, ChargeType

**LandlordServiceCharge**
- Charges to landlords (subscription, listing fees)

**PremiumServiceCharge**
- Premium feature charges

**SyndicationCharge**
- Listing syndication fees

#### 15. Credit Reporting

**AccountVerificationHistory**
- TransUnion verification audit trail
- Id, UserId, VerificationDate, Status

#### 16. Employment & Income

**EmploymentRecord**
- Tenant employment history
- Id, RentalApplicationId, Employer, JobTitle, MonthlyIncome, StartDate

**Income**
- Additional income sources
- Id, RentalApplicationId, IncomeType, Amount, Frequency

#### 17. Personal Info

**PersonalContactOfRenter**
- Emergency contacts and references
- Id, RentalApplicationId, Name, Relationship, PhoneNumber, Email

**RentalAddress**
- Previous rental addresses
- Id, RentalApplicationId, Address, City, State, Zip, MoveInDate, MoveOutDate

**Pet**
- Pet information for applications
- Id, RentalApplicationId, PetType, Breed, Weight, Name

**Vehicle**
- Vehicle information
- Id, RentalApplicationId, Make, Model, Year, Color, LicensePlate

#### 18. Notifications

**SentNotification**
- Notification audit log
- Id, UserId, NotificationType, NotificationMethod (Email, SMS, Push), SentDate, Content

#### 19. Events & Analytics

**LandlordEventRecord**
- User event tracking for analytics
- Id, UserId, EventType, EventData, Timestamp

#### 20. System Configuration

**SystemLimit**
- Rate limiting and quota management
- Id, LimitType, MaxValue, ResetPeriod

**SystemLimitTally**
- Current usage tracking for limits

### Database Relationships

**Key Relationships:**
- Property → LeasePeriod (1:Many)
- LeasePeriod → LeaseTenant (1:Many)
- LeasePeriod → Billing (1:Many)
- LeasePeriod → BillingPayment (1:Many)
- LeasePeriod → AutoBilling (1:Many)
- Property → RentalApplication (1:Many)
- Property → Lead (1:Many)
- Property → PropertyPhoto (1:Many)
- ApplicationUser → Property (1:Many as Owner)
- ApplicationUser → RentalApplication (1:Many as Applicant)
- LandlordCompany → Property (1:Many)
- LandlordCompany → ApplicationUser (Many:Many via Permissions)

### Soft Deletes
Entities implementing `ISoftDeletable` use `IsDeleted` flag instead of hard deletes, preserving data integrity and audit trails.

---

## Core Features & Business Logic

### 1. Property Listing & Management

**Property Creation Workflow:**
1. Landlord creates property with details, photos, amenities
2. Property assigned to company (if applicable)
3. Photos uploaded to Azure Blob Storage
4. Image processing creates thumbnails and optimized versions
5. Property indexed for search

**Property Visibility States:**
- **Draft** - `IsPropertyVisibleORM=false, IsPropertyActive=false`
- **Listed** - `IsPropertyVisibleORM=true, IsPropertyActive=false` (on site only)
- **Syndicated** - `IsPropertyActive=true` (on partner sites)
- **Rented** - `IsPropertyRented=true` (no longer advertised)

**Search & Filtering:**
- Full-text search on address, city, name, highlights
- Filters: bedrooms, bathrooms, price range, amenities, location
- Geolocation-based search with radius
- Pagination and sorting

### 2. Listing Syndication

**Supported Syndication Partners:**
- **Zillow** - Primary syndication partner
- **HotPads** - Secondary partner
- **OnRentMe.com** - Native listing site

**Syndication Process:**
1. Landlord enables syndication for property
2. `ListingSyndicationService` formats listing data per partner specs
3. HTTP API calls to partner syndication endpoints
4. Track syndication status per partner
5. Periodic sync to update listing data
6. Charge syndication fees to landlord

**Syndication Charges:**
- Free networks: OnRentMe.com, organic search
- Paid networks: Zillow (premium placement), HotPads
- Track `DateAdvertised` vs `DateAdvertisedPaidNetworks`

### 3. Rental Applications

**Application Process:**
1. Prospective tenant finds property
2. Submits rental application with:
   - Personal information
   - Employment history
   - Income verification
   - Previous rental addresses
   - References
   - Pet information
   - Credit check authorization
3. Payment of application fee (background check)
4. Optional: TransUnion SmartMove credit/background check
5. Landlord reviews application
6. Approve/Deny/Request more info

**Application Group Workflow:**
Multiple applicants (roommates, couples) can apply together:
1. Primary applicant creates application group
2. Invites co-applicants via email
3. Each completes their portion
4. Landlord reviews group as single unit

**Background Checks (TransUnion SmartMove):**
- Credit report
- Criminal background check
- Eviction history
- Customizable screening criteria per property
- Results integrated into application

### 4. Bidding System (Auction-Style Leasing)

**Bidding Workflow:**
1. Landlord creates lease period with `LeaseType=Bidding`
2. Sets `MinimumPrice` and optional `RentItNowPrice`
3. Prospective tenants submit bids
4. Automatic bidding: set max bid, system auto-increments
5. Landlord reviews bids and accepts one
6. Convert to standard lease

**Bid Authorization:**
- Landlord can pre-approve bidders
- `PropertyBidAuthorization` grants bidding rights
- Prevents spam bids

### 5. Lease Management

**Lease Creation:**
1. After application approval or bid acceptance
2. Create `LeasePeriod` with start/end dates
3. Link tenants via `LeaseTenant`
4. Set rent amount, deposit, terms
5. Upload signed lease documents
6. Activate lease on move-in date

**Lease Types:**
- **Fixed Term** - 6mo, 12mo, 24mo leases
- **Month-to-Month** - Rolling monthly
- **Bidding** - Auction-style (converts to Fixed)

**Lease Renewal:**
1. System alerts 60 days before expiration
2. Landlord creates renewal lease period
3. Option to adjust rent/terms
4. Tenant accepts or declines
5. New lease period linked to property

### 6. Rent Collection & Billing

**Automated Billing (`AutoBilling`):**
1. Landlord configures recurring charges:
   - Monthly rent (due day of month)
   - Utilities
   - Pet rent
   - Parking fees
2. System automatically creates `Billing` records each period
3. Tenant receives email notification

**Manual Billing:**
- Landlord creates one-time charges
- Late fees
- Damage charges
- NSF fees

**Late Fee Configuration:**
- Enable per billing or per auto-billing
- Amount (fixed or percentage)
- Grace period (days after due date)
- Auto-assessment via scheduled task

**Payment Processing:**
1. Tenant initiates payment via web/mobile
2. Select payment method (ACH or credit card)
3. Process through ProfitStars (ACH) or Braintree (CC)
4. Create `BillingPayment` record
5. Link to `PsBatchTransaction` for ACH
6. Update billing status
7. Notify landlord

**Payment Methods:**
- **ACH (Bank Account)** - Lower fees, 2-3 day processing
- **Credit/Debit Card** - Instant, higher fees
- **Manual (Cash/Check)** - Recorded by landlord

**Transaction Fees:**
- System fee: 2-5% (configurable per property)
- Processor fee: passed to tenant or landlord (configurable)
- Fee splitting between system and landlord

**Ledger System:**
- `LedgerService` maintains running balance per lease
- Tracks all charges and payments
- Calculates outstanding balance
- Generates statements

### 7. ProfitStars ACH Integration

**Landlord Setup:**
1. Create ProfitStars merchant account
2. Verify bank account (micro-deposits)
3. Complete underwriting
4. Link to `MerchantLocation`
5. Status tracked in `LandlordCompany.AchSetupComplete`

**Tenant Setup:**
1. Add bank account (routing + account number)
2. Optional: Plaid instant verification
3. Micro-deposit verification (2-3 days)
4. Store as `CustomerAccount`

**Payment Flow:**
1. Tenant authorizes ACH payment
2. Create payment record with `Status=Pending`
3. API call to ProfitStars to initiate transaction
4. Transaction added to batch
5. Batch processes (typically next business day)
6. Webhook receives status updates
7. Update payment status (`Completed`, `Failed`, `NSF`)

**Batch Processing:**
- Scheduled task fetches batch statuses from ProfitStars
- Updates local `PsBatch` and `PsBatchTransaction` records
- Triggers notifications to tenants and landlords
- Handles NSF charges and retries

### 8. Credit Card Processing (Braintree)

**Setup:**
- System-wide Braintree merchant account
- Tokenization for PCI compliance
- Hosted fields for secure input

**Payment Flow:**
1. Tenant enters card details (hosted fields)
2. Braintree tokenizes card
3. Store token in `RenterCCPaymentMethod`
4. Charge token for payment
5. Receive instant confirmation
6. Record transaction

**Recurring Payments:**
- Store payment method token
- Charge automatically on due date via scheduled task

### 9. Credit Reporting (TransUnion ShareAble)

**Landlord Enrollment:**
1. Opt-in to ShareAble program
2. Property registered with TransUnion
3. Receive `SaTuPropertyId`

**Tenant Enrollment:**
1. Tenant opts in (free for them)
2. TransUnion verification
3. Link tenant to property

**Rent Reporting:**
1. Scheduled task runs monthly
2. Identifies completed rent payments
3. Submits to TransUnion API
4. Positive payment history builds tenant credit
5. Track reporting status per payment

**Benefits:**
- Helps tenants build credit
- Incentivizes on-time payments
- Differentiator for landlords

### 10. Renters Insurance (SureApp)

**Configuration:**
- Landlord enables insurance requirement per lease
- Sets minimum coverage amount

**Tenant Flow:**
1. Lease requires insurance → prompt tenant
2. Redirect to SureApp partner link
3. Tenant purchases policy
4. Policy data synced back to RentMe
5. Store in `RentersInsurance` record
6. Periodic verification of active coverage

**Compliance Tracking:**
- Dashboard alerts for expired policies
- Email reminders before expiration
- Option to auto-charge insurance via billing

### 11. Maintenance Requests

**Tenant Submission:**
1. Tenant creates maintenance request
2. Select category and priority
3. Add description and photos
4. Submit to landlord

**Landlord Workflow:**
1. Receive email/SMS notification
2. Acknowledge request
3. Update status to `InProgress`
4. Add notes and cost estimates
5. Mark as `Completed`
6. Optional: Bill tenant for damage-related repairs

**Priority Levels:**
- **Emergency** - Immediate notification (SMS)
- **High** - 24-48 hour response
- **Medium** - 1 week response
- **Low** - Non-urgent

**Communication:**
- In-app messaging on request
- Email notifications on status changes
- Photo upload for before/after documentation

### 12. Lead Management

**Lead Capture:**
- Property detail page: contact form
- "Schedule Showing" button
- Phone number click-to-call
- Email inquiries
- External leads from Zillow, HotPads

**Lead Tracking:**
1. Lead created with source tracking
2. Landlord receives notification
3. Landlord contacts lead
4. Schedule showing
5. Track lead status through conversion
6. Metrics: source, conversion rate, time-to-contact

**Showing Scheduling:**
- Calendar integration
- Automated reminders (email/SMS)
- Confirmation tracking

### 13. Communication

**Email System:**
- SendGrid for transactional emails
- Templates for all notification types
- Landlord/tenant email preferences
- Unsubscribe management

**SMS (Telnyx):**
- Two-way SMS messaging
- Tenant-landlord communication
- Automated reminders and notifications
- SMS-to-email gateway for replies

**In-App Messaging:**
- Context-specific messaging (property, lease, maintenance)
- Notification center
- Message history

### 14. Photo & Document Management

**Photo Upload:**
1. Property photos uploaded via drag-drop or file picker
2. Upload to Azure Blob Storage
3. Image processing: resize, optimize, create thumbnails
4. Store multiple resolutions
5. CDN delivery for performance
6. Watermarking for listing photos

**Document Storage:**
- Lease agreements (PDF)
- Application documents (ID, paystubs, W-9)
- Insurance certificates
- Inspection reports
- Encrypted storage for sensitive documents

### 15. Search Engine Optimization (SEO)

**Property SEO:**
- Unique URLs per property (`/property/{id}/{slug}`)
- Meta tags optimized per listing
- Structured data (schema.org) for rich snippets
- Sitemap generation
- Pre-rendering service for SPA SEO (`RentMe.Web.Prerender`)

**Pre-rendering:**
- Headless browser renders AngularJS pages
- Serves static HTML to crawlers
- Maintains SPA UX for users

### 16. Analytics & Reporting

**Landlord Dashboard:**
- Portfolio overview
- Occupancy rates
- Revenue metrics
- Outstanding rent
- Maintenance request summary
- Lead conversion funnel

**Tenant Dashboard:**
- Payment history
- Upcoming charges
- Lease details
- Maintenance requests
- Documents

**Admin Dashboard:**
- System-wide metrics
- User growth
- Revenue (transaction fees)
- Top properties
- Support metrics

**User Event Tracking:**
- `LandlordEventRecord` captures user actions
- Integration with marketing platforms (MailChimp)
- Behavior analytics for optimization

### 17. System Limits & Quotas

**Rate Limiting:**
- API request limits per user/IP
- Photo upload limits
- Document size limits
- Prevents abuse

**Quotas:**
- Free tier: X properties, Y applications
- Paid tier: unlimited or higher limits
- Tracked via `SystemLimit` and `SystemLimitTally`

### 18. Administration

**Admin Functions:**
- User management (approve, suspend, delete)
- Property moderation
- Transaction oversight
- System configuration
- Support ticket management
- Reporting and analytics

---

## API Endpoints

All endpoints are RESTful, return JSON, and use OAuth 2.0 bearer token authentication.

### Authentication Endpoints
**Base:** `/api/Account`

```
POST   /Register                        - Register new user
POST   /Login                           - Login (returns OAuth token)
POST   /Logout                          - Logout
POST   /ChangePassword                  - Change password
POST   /ForgotPassword                  - Send password reset email
POST   /ResetPassword                   - Reset password with token
GET    /UserInfo                        - Get current user info
PUT    /UpdateProfile                   - Update user profile
POST   /VerifyEmail                     - Verify email address
POST   /ResendVerificationEmail         - Resend verification
```

### Property Endpoints
**Base:** `/api/Properties`

```
GET    /                                - Get paged active properties (public)
GET    /{id}                            - Get property details (public)
GET    /Landlord                        - Get landlord's properties
GET    /Landlord/{id}                   - Get specific landlord property
POST   /                                - Create property
PUT    /{id}                            - Update property
DELETE /{id}                            - Soft delete property
PUT    /{id}/Activate                   - Activate property (syndicate)
PUT    /{id}/Deactivate                 - Deactivate property
PUT    /{id}/MarkRented                 - Mark property as rented
GET    /{id}/Photos                     - Get property photos
POST   /{id}/Photos                     - Upload photos
DELETE /{id}/Photos/{photoId}           - Delete photo
PUT    /{id}/Photos/Reorder             - Reorder photos
GET    /{id}/LeasePeriods               - Get lease periods for property
POST   /{id}/LeasePeriods               - Create lease period
GET    /{id}/Applications               - Get applications for property
GET    /{id}/Leads                      - Get leads for property
```

### Rental Application Endpoints
**Base:** `/api/RentalApplication`

```
GET    /{id}                            - Get application details
POST   /                                - Submit application
PUT    /{id}                            - Update application
DELETE /{id}                            - Withdraw application
POST   /{id}/Approve                    - Approve application (landlord)
POST   /{id}/Deny                       - Deny application (landlord)
GET    /Property/{propertyId}           - Get applications for property
GET    /User                            - Get user's applications
POST   /{id}/BackgroundCheck            - Initiate background check
GET    /{id}/BackgroundCheckResults     - Get background check results
```

### Application Group Endpoints
**Base:** `/api/ApplicationGroup`

```
POST   /                                - Create application group
GET    /{id}                            - Get group details
POST   /{id}/Invite                     - Invite co-applicant
POST   /{id}/AcceptInvite               - Accept invitation
DELETE /{id}/Member/{memberId}          - Remove member
PUT    /{id}/Submit                     - Submit complete group
```

### Lease Endpoints
**Base:** `/api/Lease` (routes under Properties controller)

```
GET    /LeasePeriod/{id}                - Get lease period details
POST   /LeasePeriod                     - Create lease period
PUT    /LeasePeriod/{id}                - Update lease period
DELETE /LeasePeriod/{id}                - Delete lease period
GET    /LeasePeriod/{id}/Tenants        - Get tenants for lease
POST   /LeasePeriod/{id}/Tenants        - Add tenant to lease
DELETE /LeasePeriod/{id}/Tenants/{tenantId} - Remove tenant
```

### Billing Endpoints
**Base:** `/api/Billing`

```
GET    /Configuration/{propertyId}      - Get payment config for property
GET    /LandlordRentSetupStatus         - Get landlord ACH setup status
GET    /LeasePeriod/{id}                - Get billings for lease
POST   /                                - Create manual billing
PUT    /{id}                            - Update billing
DELETE /{id}                            - Delete billing
GET    /{id}/Payments                   - Get payments for billing
POST   /AutoBilling                     - Create auto-billing
GET    /AutoBilling/LeasePeriod/{id}    - Get auto-billings for lease
PUT    /AutoBilling/{id}                - Update auto-billing
DELETE /AutoBilling/{id}                - Delete auto-billing
POST   /AutoBilling/{id}/Activate       - Activate auto-billing
POST   /AutoBilling/{id}/Deactivate     - Deactivate auto-billing
GET    /Ledger/LeasePeriod/{id}         - Get ledger for lease
GET    /Statement/LeasePeriod/{id}      - Generate statement PDF
```

### Payment Endpoints
**Base:** `/api/Payments` and `/api/BillingPayment`

```
POST   /BillingPayment                  - Create payment
GET    /BillingPayment/{id}             - Get payment details
GET    /BillingPayment/LeasePeriod/{id} - Get payments for lease
POST   /BillingPayment/Refund/{id}      - Refund payment
GET    /PaymentMethods                  - Get user's payment methods
POST   /PaymentMethods/CreditCard       - Add credit card
POST   /PaymentMethods/BankAccount      - Add bank account
DELETE /PaymentMethods/{id}             - Delete payment method
PUT    /PaymentMethods/{id}/SetDefault  - Set default payment method
POST   /PaymentMethods/BankAccount/Verify - Verify bank account (micro-deposits)
```

### Maintenance Endpoints
**Base:** `/api/Maintenance`

```
GET    /{id}                            - Get maintenance request
POST   /                                - Create maintenance request
PUT    /{id}                            - Update maintenance request
GET    /LeasePeriod/{id}                - Get requests for lease
GET    /Property/{id}                   - Get requests for property
POST   /{id}/Acknowledge                - Acknowledge request (landlord)
PUT    /{id}/Status                     - Update status
POST   /{id}/Photos                     - Upload photos
GET    /{id}/Photos                     - Get photos
POST   /{id}/Complete                   - Mark as completed
POST   /{id}/Cancel                     - Cancel request
```

### Lead Endpoints
**Base:** `/api/Leads`

```
POST   /                                - Create lead (public)
GET    /{id}                            - Get lead details
GET    /Property/{propertyId}           - Get leads for property
PUT    /{id}/Status                     - Update lead status
POST   /{id}/ScheduleShowing            - Schedule showing
DELETE /{id}                            - Delete lead
GET    /Dashboard                       - Get lead dashboard stats
```

### Bid Endpoints
**Base:** `/api/Bid`

```
POST   /                                - Place bid
GET    /{id}                            - Get bid details
GET    /LeasePeriod/{id}                - Get bids for lease period
PUT    /{id}                            - Update bid
DELETE /{id}                            - Withdraw bid
POST   /{id}/Accept                     - Accept bid (landlord)
POST   /{id}/Reject                     - Reject bid (landlord)
POST   /AutoBid                         - Set up automatic bidding
```

### Dashboard Endpoints
**Base:** `/api/Dashboard`

```
GET    /Landlord                        - Get landlord dashboard data
GET    /Tenant                          - Get tenant dashboard data
GET    /Admin                           - Get admin dashboard data
GET    /Landlord/Revenue                - Revenue analytics
GET    /Landlord/Occupancy              - Occupancy analytics
GET    /Landlord/MaintenanceStats       - Maintenance statistics
```

### Company Endpoints
**Base:** `/api/Company` (routes under various controllers)

```
GET    /                                - Get company for current user
POST   /                                - Create company
PUT    /{id}                            - Update company
GET    /{id}/Permissions                - Get company permissions
POST   /{id}/Permissions                - Add user permission
DELETE /{id}/Permissions/{userId}       - Remove permission
GET    /{id}/Properties                 - Get company properties
```

### Renters Insurance Endpoints
**Base:** `/api/RentersInsurance`

```
GET    /LeasePeriod/{id}                - Get insurance for lease
POST   /                                - Record insurance policy
PUT    /{id}                            - Update insurance record
DELETE /{id}                            - Remove insurance
GET    /{id}/Verify                     - Verify active coverage
POST   /SureAppRedirect                 - Get SureApp partner URL
```

### ShareAble (Credit Reporting) Endpoints
**Base:** `/api/ShareAble`

```
POST   /Property/{id}/Enroll            - Enroll property in ShareAble
POST   /Tenant/{id}/Enroll              - Enroll tenant in ShareAble
POST   /ReportPayment                   - Report rent payment to TransUnion
GET    /Status/Property/{id}            - Get property enrollment status
GET    /Status/Tenant/{id}              - Get tenant enrollment status
```

### SmartMove (Background Check) Endpoints
**Base:** `/api/SmartMove`

```
POST   /InitiateScreening               - Start SmartMove screening
GET    /ScreeningStatus/{id}            - Get screening status
GET    /ScreeningResults/{id}           - Get screening results
POST   /InviteApplicant                 - Invite applicant to complete screening
```

### SMS Endpoints
**Base:** `/api/Sms`

```
POST   /Send                            - Send SMS
POST   /Webhook                         - Receive inbound SMS (Telnyx webhook)
GET    /Conversations/{userId}          - Get SMS conversations
GET    /Conversation/{id}               - Get conversation history
```

### Document Endpoints
**Base:** `/api/Document`

```
POST   /                                - Upload document
GET    /{id}                            - Get document
DELETE /{id}                            - Delete document
GET    /User/{userId}                   - Get user's documents
POST   /Request                         - Request document from user
GET    /Requests                        - Get document requests
POST   /Requests/{id}/Fulfill           - Fulfill document request
```

### Photo Upload Endpoints
**Base:** `/api/Photo`

```
POST   /Property/{propertyId}           - Upload property photo (multipart)
POST   /Maintenance/{requestId}         - Upload maintenance photo
POST   /Profile                         - Upload profile photo
DELETE /{id}                            - Delete photo
```

### Administration Endpoints
**Base:** `/api/Administration`

```
GET    /Users                           - Get all users (paged)
GET    /Users/{id}                      - Get user details
PUT    /Users/{id}/Approve              - Approve user
PUT    /Users/{id}/Suspend              - Suspend user
DELETE /Users/{id}                      - Delete user
GET    /Properties                      - Get all properties (admin)
PUT    /Properties/{id}/Feature         - Feature property
GET    /Transactions                    - Get all transactions
GET    /SystemStats                     - Get system statistics
```

### SEO Endpoints
**Base:** `/api/Seo`

```
GET    /Sitemap                         - Generate XML sitemap
GET    /PropertySchema/{id}             - Get schema.org JSON-LD for property
POST   /Prerender                       - Trigger pre-rendering
```

### Listing Syndication Endpoints
**Base:** `/api/ListingSyndication`

```
POST   /Property/{id}/Syndicate         - Syndicate property to partners
DELETE /Property/{id}/Syndicate         - Remove syndication
GET    /Property/{id}/Status            - Get syndication status
POST   /Property/{id}/Update            - Update syndicated listing
GET    /Status                          - Get overall syndication health
```

---

## Frontend Application

### Technology Stack
- **AngularJS 1.5.11** - MVC framework
- **UI-Router 1.0.13** - Client-side routing
- **Angular UI Bootstrap** - UI components
- **Lodash** - Utility functions
- **ng-file-upload** - File upload
- **ngMap** - Google Maps integration
- **ApexCharts** - Data visualization
- **Braintree Web SDK** - Payment forms
- **SASS** - CSS preprocessing
- **Grunt** - Build automation

### Application Structure

```
RentMe.Web.SPA/
├── Actions/              # Action creators (Flux-like pattern)
├── Components/           # Reusable UI components
├── Data/                 # Data models and constants
├── Decorators/           # Angular decorators
├── Directives/           # Custom Angular directives
├── Factories/            # Angular factories (API services)
├── Filters/              # Angular filters
├── Services/             # Angular services (business logic)
├── Templates/            # HTML templates (reusable)
├── Views/                # Page-level views
│   ├── Account/          # Login, registration, profile
│   ├── Properties/       # Property listing, details, creation
│   ├── Applications/     # Rental application forms
│   ├── Lease/            # Lease management
│   ├── Billing/          # Billing and payments
│   ├── Maintenance/      # Maintenance requests
│   ├── Dashboard/        # Landlord/tenant dashboards
│   ├── Admin/            # Admin panel
│   └── Public/           # Public pages (landing, search)
├── assets/               # Static assets
│   ├── css/              # Compiled CSS
│   ├── js/               # Third-party JavaScript
│   ├── plugins/          # jQuery plugins
│   └── img/              # Images
├── scripts/              # Application JavaScript (built by Grunt)
└── Gruntfile.js          # Build configuration
```

### Key Views & Features

#### Public Views
1. **Landing Page** - Marketing content, search box
2. **Property Search** - Filter/sort, map view, list view
3. **Property Details** - Photos, amenities, description, map, contact form
4. **About/FAQ** - Informational pages

#### Tenant Views
1. **Dashboard** - Upcoming rent, balance, maintenance requests
2. **My Applications** - Application status tracking
3. **My Leases** - Current and past leases
4. **Payment History** - Transaction history
5. **Make Payment** - Pay rent, select payment method
6. **Maintenance** - Create and track requests
7. **Documents** - Access lease documents
8. **Profile** - Update information, payment methods

#### Landlord Views
1. **Dashboard** - Portfolio overview, revenue, occupancy
2. **Properties** - List/grid view, create new
3. **Property Management** - Edit property, manage photos, lease periods
4. **Applications** - Review, approve/deny applications
5. **Tenants** - Manage tenant relationships
6. **Billing** - Create charges, view ledgers
7. **Payments** - View payment history, refunds
8. **Maintenance** - Review and manage requests
9. **Leads** - Track and convert leads
10. **Reports** - Revenue reports, occupancy reports
11. **Settings** - Company settings, payment setup

#### Admin Views
1. **User Management** - Approve, suspend, delete users
2. **Property Moderation** - Review listings
3. **Transaction Oversight** - Monitor payments
4. **System Configuration** - Fee structure, limits
5. **Analytics** - System-wide metrics

### Routing

**UI-Router State Hierarchy:**
```javascript
app
├── public
│   ├── home
│   ├── search
│   └── property-detail
├── account
│   ├── login
│   ├── register
│   ├── forgot-password
│   └── profile
├── tenant
│   ├── dashboard
│   ├── applications
│   ├── leases
│   ├── payments
│   └── maintenance
├── landlord
│   ├── dashboard
│   ├── properties
│   │   ├── list
│   │   ├── create
│   │   └── edit
│   ├── applications
│   ├── tenants
│   ├── billing
│   └── reports
└── admin
    ├── users
    ├── properties
    └── transactions
```

### API Integration

**Factories (API Services):**
- `PropertyFactory` - Property CRUD operations
- `ApplicationFactory` - Application management
- `LeaseFactory` - Lease operations
- `BillingFactory` - Billing and payment operations
- `MaintenanceFactory` - Maintenance request operations
- `AccountFactory` - User account operations
- `PhotoFactory` - Photo upload/management
- `DocumentFactory` - Document operations

**Pattern:**
```javascript
angular.module('rentme').factory('PropertyFactory', ['$http', function($http) {
  return {
    getProperties: function(page, take, query, filter) {
      return $http.get('/api/Properties', { params: {...} });
    },
    getProperty: function(id) {
      return $http.get('/api/Properties/' + id);
    },
    createProperty: function(property) {
      return $http.post('/api/Properties', property);
    },
    // ... more methods
  };
}]);
```

### Components

**Key Reusable Components:**
1. **Property Card** - Display property summary with photo, price, details
2. **Photo Gallery** - Image carousel with thumbnails
3. **Payment Form** - Credit card or bank account input (Braintree hosted fields)
4. **File Upload** - Drag-drop file upload with progress
5. **Date Picker** - Date selection
6. **Address Autocomplete** - Google Places integration
7. **Map** - Interactive property map
8. **Ledger Table** - Display charges and payments
9. **Application Form Wizard** - Multi-step application
10. **Notification Toast** - Success/error messages

### Services

**Business Logic Services:**
- `AuthService` - Authentication state management, token storage
- `UserService` - Current user information
- `ValidationService` - Form validation
- `CacheService` - Client-side caching
- `GeoLocationService` - Geolocation and maps
- `NotificationService` - Toast notifications
- `ModalService` - Modal dialog management
- `FileService` - File upload handling

### Directives

**Custom Directives:**
- `rmPropertyCard` - Property card component
- `rmPhotoGallery` - Photo gallery
- `rmCurrencyInput` - Formatted currency input
- `rmPhoneInput` - Formatted phone input with mask
- `rmDatePicker` - Date picker
- `rmFileUpload` - File upload
- `rmValidation` - Form validation decorators
- `rmPermission` - Show/hide based on user permissions

### Build Process (Grunt)

**Tasks:**
1. **SASS Compilation** - Compile SCSS to CSS
2. **JavaScript Concatenation** - Combine all JS files
3. **Minification** - Uglify JS, minify CSS
4. **Template Caching** - Pre-load Angular templates
5. **Watch** - Auto-rebuild on file changes
6. **PurifyCSS** - Remove unused CSS

**Build Configurations:**
- **Development** - Source maps, no minification, watch mode
- **Production** - Minified, concatenated, optimized

---

## Third-Party Integrations

### 1. ProfitStars ACH Processing

**Purpose:** ACH bank-to-bank transfers for rent payments

**Integration Points:**
- **Customer Management API** - Create/update customer profiles
- **Payment Processing API** - Initiate ACH transactions
- **Batch Management API** - Check batch statuses
- **Webhook Notifications** - Transaction status updates

**Flow:**
1. Landlord onboards: verify merchant account, link bank
2. Tenant onboards: add bank account, verify via micro-deposits
3. Payment initiated: create ACH transaction via API
4. Transaction batched: ProfitStars batches transactions daily
5. Processing: ACH network processes (2-3 business days)
6. Webhook: Receive status updates (completed, failed, NSF)
7. Reconciliation: Match internal records with PS batch reports

**Key Entities:**
- `CustomerAccount` - Tenant bank accounts
- `MerchantLocation` - Landlord merchant accounts
- `PsBatch` - Transaction batches
- `PsBatchTransaction` - Individual transactions
- `PsApplicationEntity` - Application linkage

**Error Handling:**
- NSF (Non-Sufficient Funds): Charge NSF fee, notify tenant
- Account closed: Notify tenant, require new payment method
- Invalid routing number: Reject immediately
- Timeout: Retry with exponential backoff

### 2. Braintree Payment Processing

**Purpose:** Credit/debit card processing

**Integration:**
- **Braintree JavaScript SDK** - Hosted fields for PCI compliance
- **Server SDK** - Create transactions, manage vault

**Flow:**
1. Tenant enters card details in hosted fields
2. Braintree tokenizes card (never touches server)
3. Token sent to server
4. Server creates transaction with token
5. Receive instant approval/decline
6. Store token for future use

**Features:**
- **Vault** - Store payment methods securely
- **Recurring Billing** - Charge stored cards
- **3D Secure** - Additional fraud protection
- **Webhooks** - Subscription events, disputes

### 3. TransUnion SmartMove (Background Checks)

**Purpose:** Credit and background screening for rental applications

**Integration:**
- **RESTful API** - Initiate screenings, retrieve reports
- **Webhook** - Screening completion notifications

**Flow:**
1. Landlord enables background checks for property
2. Applicant authorizes screening
3. API call to TransUnion to initiate
4. Applicant completes TransUnion flow
5. Webhook notifies of completion
6. Retrieve and display report

**Report Contents:**
- Credit score and report
- Criminal background check
- Eviction history
- Income insights
- Identity verification

**Landlord Controls:**
- Minimum credit score threshold
- Include/exclude medical collections
- Include/exclude foreclosures
- Bankruptcy window

### 4. TransUnion ShareAble (Credit Reporting)

**Purpose:** Report tenant rent payments to credit bureaus

**Integration:**
- **RESTful API** - Property enrollment, tenant enrollment, payment reporting
- **Webhook** - Enrollment status, reporting confirmations

**Flow:**
1. Landlord enrolls property via API
2. Tenant opts in (free for tenant)
3. TransUnion verifies tenant identity
4. Monthly: Report on-time rent payments
5. Payments appear on tenant credit report

**Benefits:**
- Tenant credit building
- Incentive for on-time payments
- Landlord differentiation

### 5. SendGrid (Email)

**Purpose:** Transactional and marketing emails

**Integration:**
- **SendGrid API v3** - Send emails programmatically
- **Templates** - Pre-designed email templates
- **Webhooks** - Delivery status, opens, clicks, bounces

**Email Types:**
- **Transactional:**
  - Registration confirmation
  - Password reset
  - Application received/approved/denied
  - Payment received
  - Maintenance request submitted/updated
  - Lease reminders
  - Late payment notifications
- **Marketing:**
  - Feature announcements
  - Tips for landlords/tenants
  - Newsletter

**Template Engine:**
- Dynamic content via Handlebars
- Personalization (name, property, amounts)
- Responsive HTML templates

### 6. Telnyx (SMS)

**Purpose:** Two-way SMS communication

**Integration:**
- **Telnyx Messaging API** - Send SMS
- **Webhooks** - Receive inbound SMS, delivery reports

**Use Cases:**
- Lead notifications to landlord
- Payment reminders
- Maintenance request alerts
- Showing confirmations
- Emergency notifications

**Flow:**
1. System sends SMS via API
2. Tenant replies (or initiates)
3. Webhook receives inbound message
4. Store in database, notify recipient
5. Two-way conversation thread

### 7. MailChimp (Marketing Automation)

**Purpose:** Email marketing campaigns and automation

**Integration:**
- **MailChimp API v3** - Sync user data, trigger campaigns
- **Audience Management** - Segment users by type, activity

**Use Cases:**
- Onboarding email sequences
- Feature announcements
- Re-engagement campaigns
- Educational content
- Event tracking for behavioral triggers

### 8. Azure Blob Storage

**Purpose:** File and image storage

**Integration:**
- **Azure Storage SDK** - Upload/download blobs
- **SAS Tokens** - Secure temporary access

**Storage Containers:**
- `property-photos` - Property listing photos
- `maintenance-photos` - Maintenance request photos
- `documents` - Lease agreements, application documents
- `profile-photos` - User avatars

**Workflow:**
1. Upload file to backend API
2. Validate file type/size
3. Generate unique filename
4. Upload to Azure Blob Storage
5. Return public URL (via CDN)
6. Store URL in database

### 9. Azure CDN

**Purpose:** Global content delivery

**Features:**
- Cache static assets (images, CSS, JS)
- Reduce origin load
- Faster page loads globally

### 10. Azure Application Insights

**Purpose:** Application performance monitoring and logging

**Integration:**
- **SDK** - Automatic instrumentation
- **Custom Events** - Track business events
- **Exceptions** - Automatic exception logging

**Monitored Metrics:**
- Request rate, response time, failure rate
- Dependency calls (DB, external APIs)
- Exceptions and stack traces
- Custom events (signups, payments, etc.)
- User sessions and page views

### 11. Google Maps / Places API

**Purpose:** Geolocation, maps, address autocomplete

**Integration:**
- **JavaScript API** - Frontend maps
- **Places Autocomplete** - Address input
- **Geocoding API** - Convert addresses to coordinates

**Features:**
- Property location map on detail page
- Search by location with radius
- Address validation and standardization

### 12. Zillow / HotPads Syndication

**Purpose:** Syndicate property listings to partner sites

**Integration:**
- **Zillow Rental Manager API** - Submit listings
- **HotPads API** - Submit listings

**Syndication Data:**
- Property details (address, beds, baths, price)
- Photos
- Description
- Contact information
- Availability

**Sync:**
- Initial push on activation
- Periodic updates (price changes, availability)
- Deactivation on rental

### 13. SureApp (Renters Insurance)

**Purpose:** Renters insurance marketplace

**Integration:**
- **Partner Link** - Redirect to SureApp with property details
- **API** - Policy data sync (policy number, coverage, expiration)
- **Webhook** - Policy purchase/renewal notifications

**Flow:**
1. Tenant clicks "Get Insurance"
2. Redirect to SureApp with property and tenant info
3. Tenant purchases policy
4. Webhook sends policy data back
5. Store and track in RentMe

---

## Background Jobs & Scheduled Tasks

**Hangfire** manages all scheduled and background tasks.

### Recurring Scheduled Tasks

**1. CreateBillingsScheduledTask**
- **Frequency:** Daily (12:00 AM)
- **Purpose:** Generate `Billing` records from `AutoBilling` configurations
- **Logic:**
  - Query all active `AutoBilling` records
  - For each, check if billing for current period exists
  - If not, create `Billing` record
  - Set due date based on `AutoBilling.DueDay`
  - Send notification to tenant

**2. AddLateFeesScheduledTask**
- **Frequency:** Daily (1:00 AM)
- **Purpose:** Assess late fees on overdue billings
- **Logic:**
  - Query all unpaid `Billing` records past due date
  - Check `LateFeesEnabled` and `DaysLateAssessFee`
  - If grace period expired and no late fee already added
  - Create additional `Billing` for late fee
  - Mark original billing as `IsLate=true`
  - Send notification to tenant and landlord

**3. CreateBillingPaymentsScheduledTask**
- **Frequency:** Daily (2:00 AM)
- **Purpose:** Process automatic payments from stored payment methods
- **Logic:**
  - Query `AutoBillingPayment` records due today
  - Find associated `Billing` records
  - Charge stored payment method
  - Create `BillingPayment` record
  - Handle failures (retry, notify user)

**4. FetchLatestPsBatchesScheduledTask**
- **Frequency:** Every 30 minutes
- **Purpose:** Sync ProfitStars batch statuses
- **Logic:**
  - Query ProfitStars API for recent batches
  - Compare with local `PsBatch` records
  - Update status (Processing, Completed, Failed)
  - Trigger notifications for completed batches

**5. FetchLatestPsTransactionStatusesScheduledTask**
- **Frequency:** Every 15 minutes
- **Purpose:** Update individual transaction statuses
- **Logic:**
  - Query ProfitStars API for transaction updates
  - Update `PsBatchTransaction` status
  - Update linked `BillingPayment` records
  - Notify users of status changes (especially failures/NSF)

**6. FetchLatestPsTransactionEventsScheduledTask**
- **Frequency:** Every hour
- **Purpose:** Process ProfitStars event stream
- **Logic:**
  - Retrieve event log from ProfitStars
  - Process events: settlements, returns, disputes
  - Update internal records
  - Handle exceptions (NSF charges, account closures)

**7. UpdateUnprocessedPsBatchesScheduledTask**
- **Frequency:** Daily (3:00 AM)
- **Purpose:** Reprocess stuck batches
- **Logic:**
  - Find batches in "Processing" status for >2 days
  - Re-query status from ProfitStars
  - Update or escalate to support

**8. SendNotificationLateLedgerScheduledTask**
- **Frequency:** Weekly (Monday 9:00 AM)
- **Purpose:** Notify tenants of overdue balances
- **Logic:**
  - Query all lease periods with outstanding balance
  - Calculate days overdue
  - Send reminder email/SMS
  - Escalate messaging based on severity

**9. SendRentersInsuranceNotificationScheduledTask**
- **Frequency:** Weekly (Tuesday 9:00 AM)
- **Purpose:** Remind tenants of insurance requirements
- **Logic:**
  - Query leases requiring insurance
  - Check for active policies
  - If missing or expiring soon, send reminder
  - Notify landlord of non-compliance

**10. SendMaintenanceNotificationScheduledTask**
- **Frequency:** Daily (9:00 AM)
- **Purpose:** Remind landlords of pending maintenance
- **Logic:**
  - Query maintenance requests not acknowledged
  - Send daily digest to landlords
  - Escalate based on priority and age

**11. SendLeadShowingNotificationScheduledTask**
- **Frequency:** Daily (8:00 AM, 4:00 PM)
- **Purpose:** Remind landlords and tenants of showings
- **Logic:**
  - Query scheduled showings for next 24 hours
  - Send reminder emails/SMS
  - Include property address and time

**12. CheckForExpiringCCScheduledTask**
- **Frequency:** Weekly (Wednesday 10:00 AM)
- **Purpose:** Notify users of expiring credit cards
- **Logic:**
  - Query payment methods expiring in next 30 days
  - Send email reminders
  - Prompt to update card

**13. MarkPropertyNotAdvertisedScheduledTask**
- **Frequency:** Daily (4:00 AM)
- **Purpose:** Deactivate expired property listings
- **Logic:**
  - Query properties with `DateAdvertised` > X days ago (e.g., 90)
  - If no recent activity, mark `IsPropertyActive=false`
  - Notify landlord

**14. MarkPropertyRentedScheduledTask**
- **Frequency:** Daily (5:00 AM)
- **Purpose:** Auto-mark properties as rented
- **Logic:**
  - Query properties with active lease starting today
  - Mark `IsPropertyRented=true`
  - Deactivate syndication

**15. CheckForFailedPaidSyndicationScheduledTask**
- **Frequency:** Daily (6:00 AM)
- **Purpose:** Retry failed syndication pushes
- **Logic:**
  - Query syndication records with failed status
  - Retry syndication API call
  - Update status or escalate after multiple failures

**16. CheckForZillowSyndicationIntervalScheduledTask**
- **Frequency:** Every 4 hours
- **Purpose:** Sync listing updates with Zillow
- **Logic:**
  - Query properties with pending updates
  - Push changes to Zillow API
  - Handle rate limits and retries

**17. MarketingUserEventUpdate**
- **Frequency:** Hourly
- **Purpose:** Sync user events to MailChimp
- **Logic:**
  - Query new `LandlordEventRecord` entries
  - Send to MailChimp via API
  - Enable behavioral email triggers

### Background Jobs (Ad-hoc)

**Image Processing:**
- Triggered on photo upload
- Resize to multiple resolutions
- Generate thumbnails
- Optimize for web
- Store in blob storage

**Report Generation:**
- Landlord requests PDF statement
- Generate PDF from HTML template
- Store in blob storage
- Send download link

**Email Sending:**
- Queue transactional emails
- Retry failed sends
- Track delivery status

**Webhook Processing:**
- Process incoming webhooks asynchronously
- Validate signatures
- Update internal records
- Trigger dependent actions

---

## Authentication & Authorization

### Authentication (ASP.NET Identity + OWIN)

**User Registration:**
1. User submits registration form (email, password, user type)
2. Validate email uniqueness
3. Hash password (PBKDF2)
4. Create `ApplicationUser` record
5. Send verification email with token
6. User verifies email via link
7. Account activated

**Login:**
1. User submits credentials
2. Validate credentials against database
3. Issue OAuth 2.0 bearer token (JWT)
4. Return token to client
5. Client stores token (localStorage)
6. Include token in `Authorization` header for API requests

**Token Structure:**
```json
{
  "access_token": "...",
  "token_type": "bearer",
  "expires_in": 86400,
  "userName": "user@example.com",
  ".issued": "...",
  ".expires": "..."
}
```

**Token Validation:**
- ASP.NET OWIN middleware validates token on each request
- Checks signature, expiration
- Loads user identity and roles

**Password Reset:**
1. User requests reset (enter email)
2. Generate reset token
3. Send email with reset link
4. User clicks link, enters new password
5. Validate token, update password

### Authorization (Roles & Permissions)

**User Roles:**
- **Tenant** - Renters
- **Landlord** - Property owners
- **Admin** - System administrators
- **PropertyManager** - Company managers

**Role-Based Authorization:**
```csharp
[Authorize(Roles = "Landlord,Admin")]
public IHttpActionResult GetLandlordProperties() { ... }

[Authorize(Roles = "Tenant")]
public IHttpActionResult MakePayment() { ... }

[AllowAnonymous]
public IHttpActionResult GetPublicProperties() { ... }
```

**Resource-Based Authorization:**
- Custom `IAccessManager` service
- Validates user permissions for specific resources
- Example: Can user edit this property?

```csharp
if (!_accessManager.CanCurrentUserManageProperty(propertyId)) {
  return Unauthorized();
}
```

**Authorization Checks:**
1. **Property Management:**
   - Owner can manage their properties
   - Company managers can manage company properties
   - Admins can manage all properties

2. **Billing Access:**
   - Landlords can view/create billings for their properties
   - Tenants can view billings for their leases
   - Both can make payments

3. **Application Review:**
   - Landlords can review applications for their properties
   - Applicants can view their own applications

4. **Company Permissions:**
   - Owner: Full access
   - Manager: Manage properties, view reports
   - ReadOnly: View-only access

**Company-Level Authorization:**
```csharp
public class LandlordCompanyPermission {
  public int CompanyId { get; set; }
  public string UserId { get; set; }
  public PermissionLevel PermissionLevel { get; set; }
}

public enum PermissionLevel {
  Owner,      // Full control
  Manager,    // Manage properties and tenants
  ReadOnly    // View-only
}
```

**Frontend Authorization:**
- AngularJS stores user roles in `AuthService`
- UI elements shown/hidden based on roles
- Routes protected with resolve functions
- Backend enforces actual authorization

---

## Infrastructure & DevOps

### Hosting (Azure)

**App Service:**
- Azure Web App for API and SPA
- App Service Plan: Standard or Premium tier
- Always On enabled
- Auto-scaling rules based on CPU/memory

**Azure Functions:**
- Consumption plan for background processing
- Triggered by HTTP, timer, queue

**Azure SQL Database:**
- Standard or Premium tier
- Automated backups (point-in-time restore)
- Geo-replication for disaster recovery
- Connection pooling for performance

**Azure Blob Storage:**
- General Purpose v2 account
- Hot tier for frequent access (photos)
- Cool tier for archives (old documents)
- Lifecycle policies to archive old data

**Azure CDN:**
- Standard Microsoft CDN
- Caching rules for static assets
- HTTPS enabled with custom domain

### Database

**Schema Management:**
- Entity Framework Code-First migrations
- Migrations stored in source control
- Applied via deployment pipeline or Hangfire job

**Connection Strings:**
- Stored in Azure App Settings (encrypted)
- Different per environment (dev, test, prod)

**Performance:**
- Indexed foreign keys
- Covering indexes on common queries
- Query plan optimization
- Connection pooling

**Backups:**
- Automated daily backups (Azure SQL)
- 7-day retention
- Manual backups before major releases

### CI/CD (Azure DevOps / TFS)

**Source Control:**
- Team Foundation Version Control (TFVC)
- Branching strategy: Dev → Test → Production
- Pull requests for code review

**Build Pipeline:**
1. Trigger on commit to Dev branch
2. Restore NuGet packages
3. Build .NET solution
4. Run unit tests
5. Build frontend (Grunt)
6. Publish artifacts

**Release Pipeline:**
1. Deploy API to Azure Web App (slot swap for zero downtime)
2. Deploy SPA to Web App (separate slot)
3. Deploy Azure Functions
4. Run database migrations
5. Smoke tests
6. Swap staging → production slots

**Environments:**
- **Dev** - Development environment, auto-deploy on commit
- **Test** - QA environment, manual promotion
- **Production** - Live environment, manual promotion with approvals

### Monitoring & Logging

**Application Insights:**
- Automatic instrumentation for requests, dependencies, exceptions
- Custom events for business metrics
- Alerting on error rates, slow requests
- Live metrics stream

**Custom Logging:**
- `ILogger` abstraction wraps Application Insights
- Structured logging with context
- Log levels: Trace, Debug, Information, Warning, Error, Critical

**Alerts:**
- Email/SMS on critical errors
- Slack integration for warnings
- PagerDuty for after-hours incidents

**Performance Monitoring:**
- Response time percentiles (p50, p95, p99)
- Database query performance
- External API latency
- Hangfire job execution time

### Security

**HTTPS:**
- Enforced on all endpoints
- Azure-managed SSL certificate
- HSTS headers

**Authentication:**
- OAuth 2.0 bearer tokens
- Token expiration (24 hours)
- Refresh token flow

**Data Encryption:**
- At rest: Azure SQL Transparent Data Encryption (TDE)
- In transit: TLS 1.2+
- Sensitive fields: Additional encryption layer

**PCI Compliance:**
- Credit card data never stored on server
- Braintree hosted fields for card input
- Tokenization for stored cards

**Input Validation:**
- Model validation attributes
- SQL injection prevention (Entity Framework parameterization)
- XSS prevention (output encoding)
- CSRF protection (anti-forgery tokens)

**Rate Limiting:**
- API rate limits per user/IP
- Distributed cache (Redis) for tracking
- 429 Too Many Requests response

**Secrets Management:**
- Azure Key Vault for sensitive config
- No secrets in source control
- Managed identities for Azure services

### Scaling

**Horizontal Scaling:**
- Azure Web App auto-scale rules
- Scale out on high CPU/memory
- Scale in during low traffic
- Min: 2 instances, Max: 10 instances

**Database Scaling:**
- Vertical: Increase DTUs as needed
- Horizontal: Read replicas for reporting
- Sharding considerations for future growth

**Caching:**
- Azure Redis Cache for session state, API responses
- In-memory caching for static data (enums, config)
- CDN for static assets

**Queue Processing:**
- Azure Service Bus for async operations
- Hangfire for scheduled jobs
- Decouples workload from web requests

---

## Migration Considerations

### Technology Recommendations

**Backend:**
- **Framework:** ASP.NET Core 8.0 (latest LTS) or Node.js with NestJS
- **Language:** C# or TypeScript
- **ORM:** Entity Framework Core or Prisma (Node)
- **Database:** PostgreSQL or continue with SQL Server
- **API:** RESTful or GraphQL
- **Real-time:** SignalR (ASP.NET) or Socket.io (Node)

**Frontend:**
- **Framework:** React 18+ with Next.js, Vue 3 with Nuxt, or Angular 17+
- **State Management:** Redux Toolkit, Zustand, or Pinia (Vue)
- **Styling:** Tailwind CSS, Material-UI, or Chakra UI
- **Forms:** React Hook Form or Formik
- **Data Fetching:** TanStack Query (React Query) or SWR
- **Build Tool:** Vite

**Infrastructure:**
- **Cloud:** Continue Azure or migrate to AWS/GCP
- **Hosting:** Azure App Service, AWS ECS/Fargate, Vercel, or Railway
- **Database:** Azure SQL, AWS RDS, or Supabase
- **Storage:** Continue Azure Blob or migrate to AWS S3
- **CDN:** Cloudflare or Fastly
- **Background Jobs:** Hangfire, BullMQ (Node), or Celery (Python)

### Migration Strategy

**Phased Migration Approach:**

**Phase 1: Infrastructure & Database**
1. Set up new cloud environment
2. Migrate database (careful schema migration)
3. Establish VPN/network connectivity
4. Test database connectivity and performance

**Phase 2: API Layer**
1. Re-implement RESTful API in new stack
2. Maintain backward compatibility with old API structure
3. Implement authentication/authorization
4. Migrate service layer logic
5. Test extensively with Postman/automated tests

**Phase 3: Background Jobs**
1. Re-implement scheduled tasks
2. Test job execution and error handling
3. Monitor job performance

**Phase 4: Frontend**
1. Set up new frontend project
2. Migrate page-by-page or feature-by-feature
3. Implement routing
4. Migrate components and views
5. Test cross-browser compatibility

**Phase 5: Integrations**
1. Re-implement third-party integrations
2. Test webhook handling
3. Verify payment processing end-to-end

**Phase 6: Testing & Cutover**
1. Load testing
2. Security audit
3. User acceptance testing (UAT)
4. Gradual rollout (beta users first)
5. Full cutover
6. Monitor closely for issues

### Data Migration

**Database Schema:**
- Export schema from SQL Server
- Convert to target database (if different)
- Adjust data types as needed (e.g., `decimal` → `numeric`)
- Re-create indexes and constraints

**Data Transfer:**
- Use ETL tool (Azure Data Factory, AWS Glue)
- Export/import scripts (CSV, SQL dumps)
- Validate data integrity (counts, checksums)
- Migrate incrementally (old data first, then recent)

**Identity Column Handling:**
- Preserve existing IDs if possible
- Map old IDs to new IDs if schema changes
- Update foreign keys accordingly

**Soft Delete Handling:**
- Preserve `IsDeleted` flags
- Ensure soft delete logic in new ORM

### API Migration

**Endpoint Compatibility:**
- Maintain same URL structure initially
- `/api/Properties` → `/api/Properties` (1:1 mapping)
- Version API if breaking changes needed (`/api/v2/...`)

**Authentication:**
- Migrate to JWT (if not already)
- OAuth 2.0 flow remains similar
- Re-issue tokens on cutover

**Error Handling:**
- Maintain same error response format
- HTTP status codes consistent
- Error messages and codes

### Frontend Migration

**Component Rewrite:**
- Break down AngularJS views into React/Vue/Angular components
- Use component library for consistency
- Maintain same UX/UI initially

**State Management:**
- Migrate from AngularJS services to Redux/Vuex/Pinia
- Centralized state for auth, user, notifications

**Routing:**
- Maintain same URL structure
- `/properties/:id` → `/properties/:id`
- Deep link compatibility

**API Integration:**
- Replace AngularJS `$http` with Axios or Fetch
- Implement request/response interceptors
- Handle authentication headers

### Integration Migration

**ProfitStars:**
- Re-implement API client in new language
- Test thoroughly in sandbox environment
- Validate webhooks with signature verification

**Braintree:**
- Use official SDK for new stack
- Migrate stored payment tokens (contact Braintree)
- Test payment flows extensively

**TransUnion:**
- Re-implement API clients
- Test in TransUnion sandbox
- Coordinate migration with TransUnion

**SendGrid:**
- Update API client
- Migrate email templates (export/import)
- Test email sending

**Telnyx:**
- Update SMS integration
- Test two-way messaging
- Update webhook endpoints

**Azure Services:**
- If staying on Azure: minimal changes
- If migrating cloud: replace with AWS/GCP equivalents
  - Blob Storage → S3
  - Application Insights → CloudWatch or Datadog

### Testing Strategy

**Unit Tests:**
- Re-implement unit tests in new framework
- Aim for 80%+ code coverage
- Focus on business logic

**Integration Tests:**
- Test API endpoints
- Test database operations
- Test third-party integrations

**End-to-End Tests:**
- Use Playwright or Cypress
- Test critical user workflows
- Payment processing (in sandbox)

**Load Testing:**
- Use JMeter, Locust, or k6
- Simulate 1000+ concurrent users
- Identify bottlenecks

**Security Testing:**
- Penetration testing
- OWASP Top 10 checks
- SQL injection, XSS, CSRF tests

### Deployment Strategy

**Blue-Green Deployment:**
1. Deploy new stack to "Green" environment
2. Route small percentage of traffic to Green
3. Monitor for errors
4. Gradually increase traffic to Green
5. Full cutover when confident
6. Keep Blue as instant rollback option

**Feature Flags:**
- Use LaunchDarkly or similar
- Enable new features gradually
- Quick rollback if issues arise

**Database Migration:**
- Run both old and new systems temporarily (if possible)
- Dual-write to both databases during transition
- Sync data periodically
- Cut over when in sync

### Monitoring Post-Migration

**Metrics to Watch:**
- Error rates (aim for <0.1%)
- Response times (maintain or improve)
- Transaction success rates (especially payments)
- User engagement (ensure no drop-off)
- Database query performance

**User Feedback:**
- In-app feedback form
- Monitor support tickets
- User surveys

**Rollback Plan:**
- Document rollback procedures
- Test rollback in staging
- Have team on standby for 48 hours post-cutover

### Cost Optimization

**Cloud Resources:**
- Right-size compute instances
- Use auto-scaling to reduce idle capacity
- Reserved instances for predictable workloads
- Spot instances for background jobs

**Database:**
- Optimize queries to reduce DTU/RCU usage
- Use read replicas for reporting
- Archive old data to cheaper storage

**Storage:**
- Lifecycle policies to move old files to cold storage
- Compress images and documents
- Use CDN to reduce origin bandwidth

**Third-Party Costs:**
- Review ProfitStars transaction fees
- Optimize Braintree usage (ACH preferred)
- Negotiate SendGrid plan based on volume

---

## Conclusion

This document provides a comprehensive blueprint for understanding and rebuilding the RentMe rental property management platform. The system encompasses property listing, tenant screening, lease management, rent collection, maintenance tracking, and integrations with major payment processors, credit bureaus, insurance providers, and listing syndication partners.

**Key Architectural Principles:**
1. **Multi-tenant architecture** supporting landlords, tenants, and companies
2. **Event-driven** background processing for billing, payments, and notifications
3. **Integration-heavy** leveraging best-in-class third-party services
4. **Scalable** cloud-native design on Azure infrastructure
5. **Secure** handling of financial and personal data with PCI compliance

**Success Metrics:**
- User growth (landlords, tenants)
- Properties listed and rented
- Transaction volume and revenue (fees)
- Payment success rates (>98%)
- User satisfaction (NPS score)
- System uptime (>99.9%)

**Future Enhancements:**
- Mobile apps (iOS, Android)
- AI-powered property recommendations
- Virtual property tours (360° photos, video)
- Blockchain-based lease contracts
- Integrated property management (accounting, taxes)
- Marketplace for contractors and services

This documentation should serve as a complete reference for rebuilding the system in a modern technology stack while preserving all business logic and user workflows.
