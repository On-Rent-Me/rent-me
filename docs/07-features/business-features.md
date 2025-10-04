# Business Features

This document covers the business-critical features of the RentMe platform including lease management, billing, payments, maintenance, listing syndication, and credit/background checks.

---

## 1. Lease Management

### Lease Creation

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

### Tenant Management

- ✅ Add tenants to lease
- ✅ Set move-in date per tenant
- ✅ Set move-out date per tenant
- ✅ Multiple tenants per lease
- ✅ Primary tenant designation
- ✅ Co-signer support
- ✅ Tenant contact information
- ✅ Tenant emergency contacts

### Lease Types

- ✅ **Fixed-Term Lease** (6, 12, 24 months)
- ✅ **Month-to-Month Lease** (rolling)
- ✅ **Bidding Lease** (converts to fixed after acceptance)
- ✅ Custom lease durations

### Lease Lifecycle

- ✅ Draft lease (not active)
- ✅ Active lease (tenants moved in)
- ✅ Expiring lease (60-day notice)
- ✅ Lease renewal process
- ✅ Lease termination (early or on-time)
- ✅ Lease extension
- ✅ Lease modification with addendums
- ✅ Lease history and audit trail

### Lease Renewal

- ✅ Auto-notification 60 days before expiration
- ✅ Landlord creates renewal offer
- ✅ Adjust rent for renewal (increase/decrease)
- ✅ Adjust terms for renewal
- ✅ Tenant accepts or declines renewal
- ✅ New lease period created upon acceptance
- ✅ Link old and new lease periods

### Lease Termination

- ✅ Tenant-initiated early termination request
- ✅ Landlord-initiated eviction process
- ✅ Mutual termination agreement
- ✅ Early termination fee calculation
- ✅ Move-out inspection scheduling
- ✅ Security deposit return process
- ✅ Final billing and ledger settlement
- ✅ Termination date tracking

### Lease Documents

- ✅ Upload signed lease agreement
- ✅ Upload lease addendums
- ✅ Upload move-in inspection reports
- ✅ Upload move-out inspection reports
- ✅ Document versioning and history
- ✅ Tenant access to lease documents
- ✅ Document download (PDF)
- ✅ E-signature integration (ready for future)

### Renters Insurance Requirement

- ✅ Enable/disable insurance requirement per lease
- ✅ Set minimum coverage amount
- ✅ Track insurance policy status
- ✅ Insurance expiration reminders
- ✅ Automatic compliance monitoring
- ✅ Integration with SureApp for policy purchase

---

## 2. Billing & Payments

### Automated Recurring Billing

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

### Manual Billing

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

### Billing Categories

- ✅ Rent
- ✅ Utilities
- ✅ Pet fees
- ✅ Parking
- ✅ Late fees
- ✅ Damage
- ✅ NSF fees
- ✅ Other/Custom

### Late Fee Management

- ✅ Enable/disable late fees per billing
- ✅ Set late fee amount (fixed or percentage)
- ✅ Set grace period (days after due date)
- ✅ Automatic late fee assessment via scheduled task
- ✅ Manual late fee creation
- ✅ Late fee waiver by landlord
- ✅ Track late payment history
- ✅ Late payment notifications to tenant

### Billing Adjustments & Corrections

- ✅ Edit billing amount before payment
- ✅ Prorate charges for partial periods
- ✅ Create credit adjustments
- ✅ Create correction billings (linked to original)
- ✅ Track full corrected amount
- ✅ Billing relationship tracking (parent/child)
- ✅ Audit trail for all changes

### Billing Notifications

- ✅ Email notification when billing created
- ✅ Email reminder 7 days before due date
- ✅ Email reminder on due date
- ✅ Email notification when late
- ✅ SMS notifications (optional)
- ✅ In-app notification center
- ✅ Customizable notification preferences

---

## 3. Rent Payment Processing

### Payment Methods (Tenant)

**ACH Bank Transfer (via ProfitStars)**
- ✅ Add bank account (routing + account number)
- ✅ Micro-deposit verification (2-3 days)
- ✅ Plaid instant verification (optional)
- ✅ Save multiple bank accounts
- ✅ Set default payment method

**Credit/Debit Card (via Braintree)**
- ✅ Add credit/debit card securely
- ✅ PCI-compliant tokenization
- ✅ Save multiple cards
- ✅ Set default payment method

**Manual Payment Recording (Cash, Check, Money Order)**
- ✅ Landlord records manual payment
- ✅ Attach payment receipt/photo
- ✅ Manual reconciliation

### Payment Initiation (Tenant)

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

### Automatic Payments

- ✅ Enable auto-pay for recurring charges
- ✅ Auto-pay on specific day of month
- ✅ Auto-pay percentage or amount of billing
- ✅ Auto-pay only when billing is created
- ✅ Auto-pay frequency configuration
- ✅ Auto-pay start and end dates
- ✅ Auto-pay notifications
- ✅ Disable auto-pay anytime
- ✅ Auto-pay failure handling and retries

### Payment Processing

**ACH Processing (ProfitStars)**
- ✅ Immediate authorization
- ✅ Batch processing (next business day)
- ✅ 2-3 day settlement
- ✅ Transaction status tracking
- ✅ Webhook updates from ProfitStars

**Credit Card Processing (Braintree)**
- ✅ Real-time authorization
- ✅ Immediate settlement
- ✅ 3D Secure fraud protection
- ✅ Instant confirmation

**General Processing**
- ✅ Transaction ID tracking
- ✅ Payment effective date
- ✅ Payment creation date
- ✅ IP address logging for security

### Transaction Fees

- ✅ System transaction fee (2-5% configurable per property)
- ✅ Processor fee (ACH: ~$1, CC: 2.9%+$0.30)
- ✅ Fee allocation (tenant pays, landlord pays, or split)
- ✅ Fee calculation and display before payment
- ✅ Separate transaction for system fees
- ✅ Fee reporting for landlords
- ✅ Fee revenue tracking for platform

### Payment Confirmation & Receipts

- ✅ Email receipt immediately after payment
- ✅ PDF receipt generation
- ✅ Receipt includes transaction ID, amount, date, method
- ✅ In-app payment confirmation page
- ✅ Push notification for successful payment
- ✅ SMS confirmation (optional)

### Payment History & Ledger

- ✅ Tenant views full payment history
- ✅ Landlord views full payment history per property
- ✅ Filter by date range
- ✅ Filter by payment method
- ✅ Filter by status (pending, completed, failed)
- ✅ Search by transaction ID
- ✅ Export payment history to CSV/Excel
- ✅ Running balance calculation (ledger)
- ✅ Aging report (30/60/90 days overdue)

### Failed Payments & NSF Handling

- ✅ Payment failure notifications (email/SMS)
- ✅ NSF (Non-Sufficient Funds) fee automatic creation
- ✅ Retry failed ACH payments (configurable)
- ✅ Account closed detection
- ✅ Invalid routing number detection
- ✅ Fraud detection and blocking
- ✅ Payment failure reason tracking
- ✅ Landlord notification of failed payments
- ✅ Tenant account restrictions after multiple failures

### Refunds

- ✅ Landlord initiates refund
- ✅ Full or partial refund
- ✅ Refund reason and notes
- ✅ Refund processing via original payment method
- ✅ Refund notification to tenant
- ✅ Refund tracking and audit trail
- ✅ Refund reporting

---

## 4. Maintenance Management

### Tenant Submission

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

### Landlord Management

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

### Status Workflow

- ✅ **Submitted** - New request from tenant
- ✅ **Acknowledged** - Landlord has seen request
- ✅ **In Progress** - Work is being done
- ✅ **Completed** - Work finished
- ✅ **Cancelled** - Request cancelled by tenant or landlord

### Priority Levels

- ✅ **Emergency** - Immediate attention (e.g., gas leak, no heat in winter)
- ✅ **High** - 24-48 hour response (e.g., broken toilet, no hot water)
- ✅ **Medium** - 1 week response (e.g., leaky faucet, broken appliance)
- ✅ **Low** - Non-urgent (e.g., cosmetic issues)

### Notifications

- ✅ Landlord email notification on new request
- ✅ Landlord SMS notification for emergency requests
- ✅ Tenant email notification on status change
- ✅ Tenant notification when marked complete
- ✅ Scheduled digest email for pending requests (daily)
- ✅ Escalation alerts for overdue requests
- ✅ In-app notification center

### Maintenance History

- ✅ Tenant views their maintenance request history
- ✅ Landlord views all maintenance for a property
- ✅ Filter by date range
- ✅ Filter by category
- ✅ Export to CSV/Excel
- ✅ Maintenance cost reporting
- ✅ Average response time metrics

### Billing Integration

- ✅ Create billing from maintenance request (for tenant-caused damage)
- ✅ Link billing to maintenance request
- ✅ Track maintenance costs in ledger

---

## 5. Listing Syndication

### Syndication Partners

- ✅ Zillow integration
- ✅ HotPads integration
- ✅ Native OnRentMe.com listings
- ✅ Enable/disable syndication per property
- ✅ Selective partner syndication

### Syndication Features

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

### Syndication Billing

- ✅ Free syndication to OnRentMe.com
- ✅ Paid syndication to Zillow (premium placement)
- ✅ Paid syndication to HotPads
- ✅ Track syndication charges per property
- ✅ Date advertised on free vs. paid networks
- ✅ Syndication fee invoicing
- ✅ Auto-charge for active paid syndication
- ✅ Syndication cost reports

---

## 6. Credit & Background Checks

### TransUnion SmartMove Integration

- ✅ Landlord enables background checks per property
- ✅ Set background check fee (passed to tenant)
- ✅ Tenant authorizes credit/background check
- ✅ Tenant pays application fee
- ✅ Initiate SmartMove screening via API
- ✅ Redirect tenant to TransUnion for identity verification
- ✅ Webhook notification on completion
- ✅ Retrieve and display screening results

### Screening Criteria Configuration

- ✅ Set minimum credit score requirement
- ✅ Configure income ratio (rent-to-income)
- ✅ Decline for open bankruptcies (with window)
- ✅ Include/exclude foreclosures
- ✅ Include/exclude medical collections
- ✅ Select screening product bundle (Basic, Plus, Premium)
- ✅ Custom screening criteria per property

### Screening Results

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

### Landlord Application Screening

- ✅ Pass/fail indicators for each criterion
- ✅ Color-coded risk assessment
- ✅ Detailed report viewing
- ✅ Download PDF reports
- ✅ Share results with property managers
- ✅ Compliance with FCRA regulations

---

## 7. Bidding System (Auction-Style Leasing)

### Bidding Configuration

- ✅ Create lease period with "Bidding" type
- ✅ Set minimum bid price
- ✅ Set optional "Rent It Now" price (buy-it-now)
- ✅ Set bidding start and end dates
- ✅ Enable/disable bidding per property

### Bidding Process (Tenant)

- ✅ View current highest bid (or starting price)
- ✅ Place manual bid
- ✅ Automatic bidding (set max bid, auto-increment)
- ✅ Bid history for tenant
- ✅ Outbid notifications via email/SMS
- ✅ Withdraw bid before acceptance
- ✅ "Rent It Now" instant lease option

### Bid Management (Landlord)

- ✅ View all bids for a property
- ✅ See bidder information (if authorized)
- ✅ Bid authorization system (pre-approve bidders)
- ✅ Accept bid and convert to lease
- ✅ Reject bid with reason
- ✅ Counter-offer functionality
- ✅ Bid expiration and auto-rejection
- ✅ Notification to winning bidder
- ✅ Notification to losing bidders

### Bidding Security

- ✅ Prevent spam bids via authorization
- ✅ Grant bidding rights to specific users
- ✅ Require application completion before bidding
- ✅ Require background check before bidding (optional)
- ✅ Bid deposit/earnest money (optional)
- ✅ Bind accepted bid to lease agreement

---

## Feature Summary

### Business Value Features

**Revenue Generation:**
- Transaction fees on rent payments
- Syndication fees for premium listings
- Application fees for background checks
- Premium service charges

**Risk Mitigation:**
- Credit and background screening
- Comprehensive application reviews
- Lease documentation and tracking
- Late fee automation

**Operational Efficiency:**
- Automated billing and payment processing
- Maintenance request tracking
- Lease lifecycle management
- Multi-property portfolio management

**Market Differentiation:**
- Credit reporting (ShareAble) for tenants
- Auction-style bidding for leases
- Multi-platform listing syndication
- Integrated renters insurance
