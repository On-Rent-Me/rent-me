# API Endpoints Reference

This document provides a comprehensive reference of all RESTful API endpoints in the RentMe platform. All endpoints return JSON and use OAuth 2.0 bearer token authentication.

**Base URL:** `/api`

---

## Authentication & Account Management

**Base:** `/api/Account`

### User Registration & Authentication

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

### Authentication Flow

**Login Request:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Login Response:**
```json
{
  "access_token": "...",
  "token_type": "bearer",
  "expires_in": 86400,
  "userName": "user@example.com",
  ".issued": "2024-01-01T00:00:00Z",
  ".expires": "2024-01-02T00:00:00Z"
}
```

---

## Property Management

**Base:** `/api/Properties`

### Property CRUD Operations

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
```

### Property Photos

```
GET    /{id}/Photos                     - Get property photos
POST   /{id}/Photos                     - Upload photos
DELETE /{id}/Photos/{photoId}           - Delete photo
PUT    /{id}/Photos/Reorder             - Reorder photos
```

### Property Relationships

```
GET    /{id}/LeasePeriods               - Get lease periods for property
POST   /{id}/LeasePeriods               - Create lease period
GET    /{id}/Applications               - Get applications for property
GET    /{id}/Leads                      - Get leads for property
```

### Query Parameters

**Property Search:**
```
?city=Seattle&state=WA&bedrooms=2&bathrooms=1&minPrice=1000&maxPrice=2000&page=1&pageSize=15
```

---

## Rental Applications

**Base:** `/api/RentalApplication`

### Application Management

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

---

## Application Groups

**Base:** `/api/ApplicationGroup`

### Group Applications (Roommates)

```
POST   /                                - Create application group
GET    /{id}                            - Get group details
POST   /{id}/Invite                     - Invite co-applicant
POST   /{id}/AcceptInvite               - Accept invitation
DELETE /{id}/Member/{memberId}          - Remove member
PUT    /{id}/Submit                     - Submit complete group
```

---

## Lease Management

**Base:** `/api/Lease` (routes under Properties controller)

### Lease Period Operations

```
GET    /LeasePeriod/{id}                - Get lease period details
POST   /LeasePeriod                     - Create lease period
PUT    /LeasePeriod/{id}                - Update lease period
DELETE /LeasePeriod/{id}                - Delete lease period
GET    /LeasePeriod/{id}/Tenants        - Get tenants for lease
POST   /LeasePeriod/{id}/Tenants        - Add tenant to lease
DELETE /LeasePeriod/{id}/Tenants/{tenantId} - Remove tenant
```

---

## Billing & Invoicing

**Base:** `/api/Billing`

### Configuration & Setup

```
GET    /Configuration/{propertyId}      - Get payment config for property
GET    /LandlordRentSetupStatus         - Get landlord ACH setup status
```

### Billing Operations

```
GET    /LeasePeriod/{id}                - Get billings for lease
POST   /                                - Create manual billing
PUT    /{id}                            - Update billing
DELETE /{id}                            - Delete billing
GET    /{id}/Payments                   - Get payments for billing
```

### Auto-Billing

```
POST   /AutoBilling                     - Create auto-billing
GET    /AutoBilling/LeasePeriod/{id}    - Get auto-billings for lease
PUT    /AutoBilling/{id}                - Update auto-billing
DELETE /AutoBilling/{id}                - Delete auto-billing
POST   /AutoBilling/{id}/Activate       - Activate auto-billing
POST   /AutoBilling/{id}/Deactivate     - Deactivate auto-billing
```

### Ledger & Statements

```
GET    /Ledger/LeasePeriod/{id}         - Get ledger for lease
GET    /Statement/LeasePeriod/{id}      - Generate statement PDF
```

---

## Payment Processing

**Base:** `/api/Payments` and `/api/BillingPayment`

### Payment Operations

```
POST   /BillingPayment                  - Create payment
GET    /BillingPayment/{id}             - Get payment details
GET    /BillingPayment/LeasePeriod/{id} - Get payments for lease
POST   /BillingPayment/Refund/{id}      - Refund payment
```

### Payment Methods

```
GET    /PaymentMethods                  - Get user's payment methods
POST   /PaymentMethods/CreditCard       - Add credit card
POST   /PaymentMethods/BankAccount      - Add bank account
DELETE /PaymentMethods/{id}             - Delete payment method
PUT    /PaymentMethods/{id}/SetDefault  - Set default payment method
POST   /PaymentMethods/BankAccount/Verify - Verify bank account (micro-deposits)
```

---

## Maintenance Requests

**Base:** `/api/Maintenance`

### Request Management

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

---

## Lead Management

**Base:** `/api/Leads`

### Lead Operations

```
POST   /                                - Create lead (public)
GET    /{id}                            - Get lead details
GET    /Property/{propertyId}           - Get leads for property
PUT    /{id}/Status                     - Update lead status
POST   /{id}/ScheduleShowing            - Schedule showing
DELETE /{id}                            - Delete lead
GET    /Dashboard                       - Get lead dashboard stats
```

---

## Bidding System

**Base:** `/api/Bid`

### Bid Operations

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

---

## Dashboard Analytics

**Base:** `/api/Dashboard`

### User Dashboards

```
GET    /Landlord                        - Get landlord dashboard data
GET    /Tenant                          - Get tenant dashboard data
GET    /Admin                           - Get admin dashboard data
GET    /Landlord/Revenue                - Revenue analytics
GET    /Landlord/Occupancy              - Occupancy analytics
GET    /Landlord/MaintenanceStats       - Maintenance statistics
```

---

## Company Management

**Base:** `/api/Company` (routes under various controllers)

### Company Operations

```
GET    /                                - Get company for current user
POST   /                                - Create company
PUT    /{id}                            - Update company
GET    /{id}/Permissions                - Get company permissions
POST   /{id}/Permissions                - Add user permission
DELETE /{id}/Permissions/{userId}       - Remove permission
GET    /{id}/Properties                 - Get company properties
```

---

## Renters Insurance

**Base:** `/api/RentersInsurance`

### Insurance Operations

```
GET    /LeasePeriod/{id}                - Get insurance for lease
POST   /                                - Record insurance policy
PUT    /{id}                            - Update insurance record
DELETE /{id}                            - Remove insurance
GET    /{id}/Verify                     - Verify active coverage
POST   /SureAppRedirect                 - Get SureApp partner URL
```

---

## Credit Reporting (ShareAble)

**Base:** `/api/ShareAble`

### ShareAble Operations

```
POST   /Property/{id}/Enroll            - Enroll property in ShareAble
POST   /Tenant/{id}/Enroll              - Enroll tenant in ShareAble
POST   /ReportPayment                   - Report rent payment to TransUnion
GET    /Status/Property/{id}            - Get property enrollment status
GET    /Status/Tenant/{id}              - Get tenant enrollment status
```

---

## Background Checks (SmartMove)

**Base:** `/api/SmartMove`

### Screening Operations

```
POST   /InitiateScreening               - Start SmartMove screening
GET    /ScreeningStatus/{id}            - Get screening status
GET    /ScreeningResults/{id}           - Get screening results
POST   /InviteApplicant                 - Invite applicant to complete screening
```

---

## Communication

### SMS Messaging

**Base:** `/api/Sms`

```
POST   /Send                            - Send SMS
POST   /Webhook                         - Receive inbound SMS (Telnyx webhook)
GET    /Conversations/{userId}          - Get SMS conversations
GET    /Conversation/{id}               - Get conversation history
```

---

## Document Management

**Base:** `/api/Document`

### Document Operations

```
POST   /                                - Upload document
GET    /{id}                            - Get document
DELETE /{id}                            - Delete document
GET    /User/{userId}                   - Get user's documents
POST   /Request                         - Request document from user
GET    /Requests                        - Get document requests
POST   /Requests/{id}/Fulfill           - Fulfill document request
```

---

## Photo Upload

**Base:** `/api/Photo`

### Photo Operations

```
POST   /Property/{propertyId}           - Upload property photo (multipart)
POST   /Maintenance/{requestId}         - Upload maintenance photo
POST   /Profile                         - Upload profile photo
DELETE /{id}                            - Delete photo
```

---

## Administration

**Base:** `/api/Administration`

### User Management

```
GET    /Users                           - Get all users (paged)
GET    /Users/{id}                      - Get user details
PUT    /Users/{id}/Approve              - Approve user
PUT    /Users/{id}/Suspend              - Suspend user
DELETE /Users/{id}                      - Delete user
```

### Property & Transaction Management

```
GET    /Properties                      - Get all properties (admin)
PUT    /Properties/{id}/Feature         - Feature property
GET    /Transactions                    - Get all transactions
GET    /SystemStats                     - Get system statistics
```

---

## SEO & Syndication

### SEO Operations

**Base:** `/api/Seo`

```
GET    /Sitemap                         - Generate XML sitemap
GET    /PropertySchema/{id}             - Get schema.org JSON-LD for property
POST   /Prerender                       - Trigger pre-rendering
```

### Listing Syndication

**Base:** `/api/ListingSyndication`

```
POST   /Property/{id}/Syndicate         - Syndicate property to partners
DELETE /Property/{id}/Syndicate         - Remove syndication
GET    /Property/{id}/Status            - Get syndication status
POST   /Property/{id}/Update            - Update syndicated listing
GET    /Status                          - Get overall syndication health
```

---

## Common Request/Response Patterns

### Standard Error Response

```json
{
  "error": "string",
  "error_description": "Detailed error message",
  "modelState": {
    "field": ["Validation error"]
  }
}
```

### HTTP Status Codes

- `200 OK` - Successful request
- `201 Created` - Resource created successfully
- `204 No Content` - Successful request with no response body
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `409 Conflict` - Resource conflict (duplicate)
- `422 Unprocessable Entity` - Validation errors
- `429 Too Many Requests` - Rate limit exceeded
- `500 Internal Server Error` - Server error

### Pagination

**Request:**
```
GET /api/Properties?page=1&pageSize=15
```

**Response:**
```json
{
  "data": [...],
  "totalCount": 150,
  "page": 1,
  "pageSize": 15,
  "totalPages": 10
}
```

### Authentication Header

All authenticated requests must include:
```
Authorization: Bearer {access_token}
```

---

## API Versioning

Currently using v1 (implicit in URL structure). Future versions will use explicit versioning:

```
/api/v2/Properties
```

---

## Rate Limiting

- **Anonymous users**: 100 requests/hour
- **Authenticated users**: 1000 requests/hour
- **Admin users**: Unlimited

Rate limit headers included in responses:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1609459200
```

---

## Webhooks

The platform sends webhooks for external service integrations:

### ProfitStars Webhook

```
POST /api/Webhooks/ProfitStars
```

### TransUnion Webhook

```
POST /api/Webhooks/TransUnion
```

### SendGrid Webhook

```
POST /api/Webhooks/SendGrid
```

### Telnyx Webhook

```
POST /api/Webhooks/Telnyx
```

All webhooks include signature verification for security.
