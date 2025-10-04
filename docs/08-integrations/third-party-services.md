# Third-Party Integrations

This document details all third-party service integrations used in the RentMe platform, including payment processors, credit bureaus, insurance providers, communication services, and cloud infrastructure.

---

## 1. ProfitStars ACH Processing

### Purpose
ACH bank-to-bank transfers for rent payments with lower transaction fees and 2-3 day processing time.

### Integration Points

- **Customer Management API** - Create/update customer profiles
- **Payment Processing API** - Initiate ACH transactions
- **Batch Management API** - Check batch statuses
- **Webhook Notifications** - Transaction status updates

### Landlord Onboarding (Merchant Setup)

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

### Tenant Onboarding (Customer Setup)

- ✅ Create ProfitStars customer account
- ✅ Link customer to specific merchant (landlord)
- ✅ Add bank account information
- ✅ Verify bank account via micro-deposits
- ✅ Alternative: Plaid instant verification
- ✅ Account registration confirmation
- ✅ Store account reference ID
- ✅ Support multiple bank accounts per tenant

### Payment Flow

1. Landlord onboards: verify merchant account, link bank
2. Tenant onboards: add bank account, verify via micro-deposits
3. Payment initiated: create ACH transaction via API
4. Transaction batched: ProfitStars batches transactions daily
5. Processing: ACH network processes (2-3 business days)
6. Webhook: Receive status updates (completed, failed, NSF)
7. Reconciliation: Match internal records with PS batch reports

### Payment Processing

- ✅ Initiate ACH transaction via API
- ✅ Debit from tenant account
- ✅ Credit to landlord merchant account
- ✅ Transaction batching (daily)
- ✅ Batch submission to ACH network
- ✅ Transaction status tracking (Pending → Processing → Settled)
- ✅ Settlement status tracking
- ✅ Effective date tracking
- ✅ Response code and message handling

### Batch Management

- ✅ Fetch latest batches from ProfitStars
- ✅ Scheduled task to sync batch statuses (every 30 min)
- ✅ Update local batch records with ProfitStars data
- ✅ Link batch transactions to billing payments
- ✅ Reconcile batch amounts
- ✅ Handle batch-level errors
- ✅ Batch reporting for landlords

### Transaction Event Tracking

- ✅ Scheduled task to fetch transaction events (every 15 min)
- ✅ Transaction status updates (Authorized, Scheduled, Settled, Failed)
- ✅ Settlement status updates
- ✅ Return handling (NSF, Account Closed, etc.)
- ✅ Webhook support for real-time updates
- ✅ Payment history audit trail
- ✅ Store all transaction events for compliance

### Error Handling & Recovery

- ✅ NSF (Non-Sufficient Funds) detection and fee assessment
- ✅ Account closed error handling
- ✅ Invalid routing number detection
- ✅ Payment retry logic for transient errors
- ✅ Stuck batch detection and reprocessing
- ✅ Manual reconciliation tools for admins
- ✅ ProfitStars API error logging

### Key Entities

- `CustomerAccount` - Tenant bank accounts
- `MerchantLocation` - Landlord merchant accounts
- `PsBatch` - Transaction batches
- `PsBatchTransaction` - Individual transactions
- `PsApplicationEntity` - Application linkage

---

## 2. Braintree Payment Processing

### Purpose
Credit/debit card processing with instant settlement and PCI compliance through tokenization.

### Integration

- **Braintree JavaScript SDK** - Hosted fields for PCI compliance
- **Server SDK** - Create transactions, manage vault
- **Webhooks** - Subscription events, disputes

### Setup

- System-wide Braintree merchant account
- Tokenization for PCI compliance
- Hosted fields for secure input

### Payment Flow

1. Tenant enters card details (hosted fields)
2. Braintree tokenizes card (never touches server)
3. Token sent to server
4. Server creates transaction with token
5. Receive instant approval/decline
6. Store token for future use

### Features

- **Vault** - Store payment methods securely
- **Recurring Billing** - Charge stored cards
- **3D Secure** - Additional fraud protection
- **Webhooks** - Subscription events, disputes

### Credit Card Processing

- ✅ Real-time authorization
- ✅ Immediate settlement
- ✅ 3D Secure fraud protection
- ✅ Instant confirmation

### Payment Methods

- ✅ Add credit/debit card securely
- ✅ PCI-compliant tokenization
- ✅ Save multiple cards
- ✅ Set default payment method

---

## 3. TransUnion SmartMove (Background Checks)

### Purpose
Credit and background screening for rental applications with comprehensive reporting.

### Integration

- **RESTful API** - Initiate screenings, retrieve reports
- **Webhook** - Screening completion notifications

### Flow

1. Landlord enables background checks for property
2. Applicant authorizes screening
3. API call to TransUnion to initiate
4. Applicant completes TransUnion flow
5. Webhook notifies of completion
6. Retrieve and display report

### Report Contents

- Credit score and report
- Criminal background check
- Eviction history
- Income insights
- Identity verification

### Landlord Controls

- Minimum credit score threshold
- Include/exclude medical collections
- Include/exclude foreclosures
- Bankruptcy window

### Screening Configuration

- ✅ Set minimum credit score requirement
- ✅ Configure income ratio (rent-to-income)
- ✅ Decline for open bankruptcies (with window)
- ✅ Include/exclude foreclosures
- ✅ Include/exclude medical collections
- ✅ Select screening product bundle (Basic, Plus, Premium)
- ✅ Custom screening criteria per property

---

## 4. TransUnion ShareAble (Credit Reporting)

### Purpose
Report tenant rent payments to credit bureaus to help tenants build credit history.

### Integration

- **RESTful API** - Property enrollment, tenant enrollment, payment reporting
- **Webhook** - Enrollment status, reporting confirmations

### Flow

1. Landlord enrolls property via API
2. Tenant opts in (free for tenant)
3. TransUnion verifies tenant identity
4. Monthly: Report on-time rent payments
5. Payments appear on tenant credit report

### Benefits

- Tenant credit building
- Incentive for on-time payments
- Landlord differentiation

### Features

- ✅ Landlord property enrollment
- ✅ Tenant identity verification
- ✅ Monthly payment reporting
- ✅ On-time payment tracking
- ✅ Late payment reporting (optional)
- ✅ Missed payment reporting (optional)

---

## 5. SendGrid (Email Delivery)

### Purpose
Transactional and marketing emails with delivery tracking and templates.

### Integration

- **SendGrid API v3** - Send emails programmatically
- **Templates** - Pre-designed email templates
- **Webhooks** - Delivery status, opens, clicks, bounces

### Email Types

**Transactional:**
- Registration confirmation
- Password reset
- Application received/approved/denied
- Payment received
- Maintenance request submitted/updated
- Lease reminders
- Late payment notifications

**Marketing:**
- Feature announcements
- Tips for landlords/tenants
- Newsletter

### Template Engine

- Dynamic content via Handlebars
- Personalization (name, property, amounts)
- Responsive HTML templates

### Features

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

---

## 6. Telnyx (SMS Messaging)

### Purpose
Two-way SMS communication for critical notifications and tenant-landlord messaging.

### Integration

- **Telnyx Messaging API** - Send SMS
- **Webhooks** - Receive inbound SMS, delivery reports

### Use Cases

- Lead notifications to landlord
- Payment reminders
- Maintenance request alerts
- Showing confirmations
- Emergency notifications

### Flow

1. System sends SMS via API
2. Tenant replies (or initiates)
3. Webhook receives inbound message
4. Store in database, notify recipient
5. Two-way conversation thread

### Features

- ✅ Two-way SMS messaging
- ✅ SMS notifications for critical events
- ✅ SMS opt-in/opt-out management
- ✅ Phone number validation
- ✅ Carrier lookup
- ✅ SMS delivery tracking
- ✅ SMS rate limiting
- ✅ SMS reply handling
- ✅ SMS-to-email gateway for landlords

---

## 7. MailChimp (Marketing Automation)

### Purpose
Email marketing campaigns and automation with user segmentation.

### Integration

- **MailChimp API v3** - Sync user data, trigger campaigns
- **Audience Management** - Segment users by type, activity

### Use Cases

- Onboarding email sequences
- Feature announcements
- Re-engagement campaigns
- Educational content
- Event tracking for behavioral triggers

### Features

- ✅ User segmentation (landlords, tenants, active, inactive)
- ✅ Email campaigns for feature announcements
- ✅ Drip campaigns for onboarding
- ✅ Re-engagement campaigns
- ✅ Event tracking sync (user actions → MailChimp)
- ✅ Behavioral email triggers
- ✅ A/B testing for campaigns
- ✅ Campaign performance analytics

---

## 8. SureApp (Renters Insurance)

### Purpose
Renters insurance marketplace integrated into lease requirements.

### Integration

- **Partner Link** - Redirect to SureApp with property details
- **API** - Policy data sync (policy number, coverage, expiration)
- **Webhook** - Policy purchase/renewal notifications

### Flow

1. Tenant clicks "Get Insurance"
2. Redirect to SureApp with property and tenant info
3. Tenant purchases policy
4. Webhook sends policy data back
5. Store and track in RentMe

### Features

- ✅ Landlord enables insurance requirement per lease
- ✅ Set minimum coverage amount
- ✅ Redirect to SureApp partner portal
- ✅ Pre-fill property and tenant information
- ✅ Multiple coverage options (basic, standard, premium)
- ✅ Policy data sync from SureApp
- ✅ Track policy status on tenant dashboard
- ✅ Policy renewal reminders (60, 30, 7 days before expiration)
- ✅ Expired policy alerts to landlord and tenant

---

## 9. Azure Services

### Azure Blob Storage

**Purpose:** File and image storage with secure access.

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

### Azure CDN

**Purpose:** Global content delivery for static assets.

**Features:**
- Cache static assets (images, CSS, JS)
- Reduce origin load
- Faster page loads globally
- HTTPS enabled with custom domain
- Caching rules for static assets

### Azure Application Insights

**Purpose:** Application performance monitoring and logging.

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

### Azure Functions

**Purpose:** Serverless background processing.

**Features:**
- Consumption plan for background processing
- Triggered by HTTP, timer, queue
- Image processing tasks
- Report generation
- Webhook processing

---

## 10. Google Maps / Places API

### Purpose
Geolocation, maps, and address autocomplete for property listings.

### Integration

- **JavaScript API** - Frontend maps
- **Places Autocomplete** - Address input
- **Geocoding API** - Convert addresses to coordinates

### Features

- Property location map on detail page
- Search by location with radius
- Address validation and standardization
- Interactive property maps
- Geolocation markers

---

## 11. Zillow / HotPads Syndication

### Purpose
Syndicate property listings to major rental platforms for increased visibility.

### Integration

- **Zillow Rental Manager API** - Submit listings
- **HotPads API** - Submit listings

### Syndication Data

- Property details (address, beds, baths, price)
- Photos
- Description
- Contact information
- Availability

### Sync

- Initial push on activation
- Periodic updates (price changes, availability)
- Deactivation on rental
- Scheduled re-sync (every 4 hours for Zillow)

### Features

- ✅ One-click syndication to all partners
- ✅ Automatic listing formatting per partner specs
- ✅ Photo optimization for each partner
- ✅ Property description adaptation
- ✅ Contact information management
- ✅ Availability calendar sync
- ✅ Pricing updates propagation
- ✅ Automatic deactivation when rented

---

## 12. Plaid (Optional Bank Verification)

### Purpose
Instant bank account verification alternative to micro-deposits.

### Integration

- **Plaid Link** - Frontend bank connection widget
- **Plaid API** - Verify account ownership and details

### Features

- Instant bank account verification
- Alternative to 2-3 day micro-deposit process
- Enhanced user experience
- Reduced fraud risk

---

## Integration Summary

### Payment Processing
- **ProfitStars**: ACH bank transfers (primary rent collection)
- **Braintree**: Credit card processing (application fees, backup payment method)

### Screening & Reporting
- **TransUnion SmartMove**: Credit and background checks
- **TransUnion ShareAble**: Credit reporting for tenants

### Communication
- **SendGrid**: Email delivery and templates
- **Telnyx**: SMS messaging and notifications

### Marketing
- **MailChimp**: Email marketing and automation

### Insurance
- **SureApp**: Renters insurance marketplace

### Cloud Infrastructure
- **Azure Blob Storage**: File storage
- **Azure CDN**: Content delivery
- **Azure Application Insights**: Monitoring
- **Azure Functions**: Background processing

### Listing Distribution
- **Zillow**: Rental listing syndication
- **HotPads**: Rental listing syndication

### Maps & Location
- **Google Maps/Places**: Geolocation and address services

### Optional Services
- **Plaid**: Instant bank verification
