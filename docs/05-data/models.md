# RentMe Database Models Reference

**Total Models**: 55 tables
**Last Updated**: October 3, 2025

---

## Authentication & Authorization (5 models)

| Model | Table | Description |
|-------|-------|-------------|
| **User** | `asp_net_users` | User accounts (landlords, renters, admins) with ASP.NET Identity |
| **Role** | `asp_net_roles` | User roles for authorization |
| **UserClaim** | `asp_net_user_claims` | User claims for fine-grained permissions |
| **UserLogin** | `asp_net_user_logins` | External authentication providers (Google, Facebook) |
| **UserRole** | `asp_net_user_roles` | Join table for users and roles (many-to-many) |

---

## Properties & Listings (8 models)

| Model | Table | Description |
|-------|-------|-------------|
| **Property** | `properties` | Rental property listings with address, rent, amenities |
| **PropertyPhoto** | `property_photos` | Property images (URLs, order, captions) |
| **PropertyNote** | `property_notes` | Landlord notes about properties |
| **PropertyNoteAppliance** | `property_note_appliances` | Appliance details in property notes |
| **PropertyGroup** | `property_groups` | Property grouping/categorization |
| **PropertyListingTag** | `property_listing_tags` | Tags for property listings (featured, premium, etc.) |
| **PropertyBidAuthorization** | `property_bid_authorizations` | Authorization for bidding on properties |
| **Bid** | `bids` | Renter bids on auction-style properties |

---

## Rental Applications (11 models)

| Model | Table | Description |
|-------|-------|-------------|
| **RentalApplication** | `rental_applications` | Renter applications to lease properties |
| **ApplicationGroup** | `application_groups` | Group applications (roommates applying together) |
| **ApplicationGroupMember** | `application_group_members` | Members of group applications |
| **ApplicationReview** | `application_reviews` | Landlord reviews of applications (approve/reject) |
| **EmploymentRecord** | `employment_records` | Applicant employment history |
| **Income** | `incomes` | Applicant income sources |
| **RentalAddress** | `rental_addresses` | Applicant previous rental addresses |
| **Pet** | `pets` | Applicant pet information |
| **Vehicle** | `vehicles` | Applicant vehicle information |
| **PhoneNumber** | `phone_numbers` | Applicant phone numbers |
| **PersonalContactOfRenter** | `personal_contact_of_renters` | Applicant emergency contacts/references |

---

## Leases & Tenants (2 models)

| Model | Table | Description |
|-------|-------|-------------|
| **LeasePeriod** | `lease_periods` | Active leases with start/end dates, rent amount |
| **LeaseTenant** | `lease_tenants` | Tenants associated with lease periods |

---

## Billing & Payments (11 models)

| Model | Table | Description |
|-------|-------|-------------|
| **Billing** | `billings` | Rent bills, charges, late fees |
| **BillingPayment** | `billing_payments` | Payments applied to billings |
| **BillingPaymentHistory** | `billing_payment_histories` | Payment history/audit trail |
| **BillingReference** | `billing_references` | References between billings (late fees, corrections) |
| **BillingPaymentNsfCharge** | `billing_payment_nsf_charges` | NSF (insufficient funds) charges |
| **AutoBilling** | `auto_billings` | Recurring billing configurations (rent, utilities) |
| **AutoBillingPayment** | `auto_billing_payments` | Scheduled automatic payments |
| **Payment** | `payments` | Payment transaction records |
| **CustomerAccount** | `customer_accounts` | ProfitStars customer payment accounts |
| **MerchantLocation** | `merchant_locations` | ProfitStars merchant locations |
| **CCPaymentMethod** | `cc_payment_methods` | Credit card payment methods |

---

## ProfitStars Integration (3 models)

| Model | Table | Description |
|-------|-------|-------------|
| **PsBatch** | `ps_batches` | ProfitStars ACH payment batches |
| **PsBatchTransaction** | `ps_batch_transactions` | Individual transactions in batches |
| **PsApplicationEntity** | `ps_application_entities` | ProfitStars application references |

---

## Landlord Management (3 models)

| Model | Table | Description |
|-------|-------|-------------|
| **LandlordCompany** | `landlord_companies` | Property management companies |
| **LandlordCompanyPermission** | `landlord_company_permissions` | User permissions within companies |
| **LandlordEventRecord** | `landlord_event_records` | Activity/event tracking for landlords |

---

## Account Management (3 models)

| Model | Table | Description |
|-------|-------|-------------|
| **AccountDocument** | `account_documents` | User-uploaded documents (ID, pay stubs, etc.) |
| **AccountDocumentRequest** | `account_document_requests` | Document requests from landlords |
| **AccountVerificationHistory** | `account_verification_histories` | Account verification audit trail |

---

## Maintenance (2 models)

| Model | Table | Description |
|-------|-------|-------------|
| **MaintenanceRequest** | `maintenance_requests` | Tenant maintenance requests |
| **MaintenanceRequestPhoto** | `maintenance_request_photos` | Photos attached to maintenance requests |

---

## Leads & Marketing (2 models)

| Model | Table | Description |
|-------|-------|-------------|
| **Lead** | `leads` | Marketing leads (prospective users) |
| **SentNotification** | `sent_notifications` | Email/SMS notifications sent to users |

---

## Insurance & Services (3 models)

| Model | Table | Description |
|-------|-------|-------------|
| **RentersInsurance** | `renters_insurances` | SureApp renters insurance policies |
| **ServiceCharge** | `service_charges` | Premium service charges (background checks, etc.) |
| **PhoneLookupInfo** | `phone_lookup_infos` | Phone number lookup/validation data |

---

## System Configuration (2 models)

| Model | Table | Description |
|-------|-------|-------------|
| **SystemLimit** | `system_limits` | System usage limits (properties per landlord, etc.) |
| **SystemLimitTally** | `system_limit_tallies` | Current usage counts for limits |

---

## Quick Reference by Domain

### **Property Management Flow**
```
Property → PropertyPhoto → Bid → RentalApplication → LeasePeriod → LeaseTenant
```

### **Billing Flow**
```
LeasePeriod → AutoBilling → Billing → BillingPayment → Payment
```

### **Application Flow**
```
Property → RentalApplication → ApplicationReview → LeasePeriod
```

### **Payment Processing Flow**
```
BillingPayment → CustomerAccount → PsBatch → PsBatchTransaction
```

---

## Model Conventions

### Common Fields (Present in Most Tables)

| Field | Type | Description |
|-------|------|-------------|
| `Id` | integer/string | Primary key |
| `IsDeleted` | boolean | Soft delete flag |
| `DateCreated` | datetime | Creation timestamp |
| `DateModified` | datetime | Last update timestamp |
| `UserId` | string | Foreign key to `asp_net_users` |

### Soft Delete Pattern
Almost all tables use soft delete (set `IsDeleted = true` instead of actual deletion).

### Foreign Key Naming
- `UserId` → References `asp_net_users.Id`
- `PropertyId` → References `properties.Id`
- `LeasePeriodId` → References `lease_periods.Id`
- `CompanyId` → References `landlord_companies.Id`

---

## Total Counts by Category

| Category | Count | Percentage |
|----------|-------|------------|
| Authentication & Authorization | 5 | 9% |
| Properties & Listings | 8 | 15% |
| Rental Applications | 11 | 20% |
| Leases & Tenants | 2 | 4% |
| Billing & Payments | 11 | 20% |
| ProfitStars Integration | 3 | 5% |
| Landlord Management | 3 | 5% |
| Account Management | 3 | 5% |
| Maintenance | 2 | 4% |
| Leads & Marketing | 2 | 4% |
| Insurance & Services | 3 | 5% |
| System Configuration | 2 | 4% |
| **TOTAL** | **55** | **100%** |
