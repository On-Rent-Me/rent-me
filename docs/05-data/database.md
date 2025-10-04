
  ---
  Core Entity Groups

  1. User Management (ASP.NET Identity)

  AspNetUsers - User accounts
  - Id (string, PK), UserName, Email, PasswordHash, SecurityStamp
  - UserType (int) - 0=Tenant, 1=Landlord, 2=Admin
  - FirstName, LastName, PhoneNumber, PhoneNumberConfirmed
  - EmailConfirmed, TwoFactorEnabled, LockoutEnabled
  - DateCreated

  AspNetRoles, AspNetUserRoles, AspNetUserClaims, AspNetUserLogins - Standard Identity tables

  ---
  2. Property Management

  Properties
  - Id (int, PK, Identity)
  - Name, Address, City, State (enum), Zip, UnitNumber
  - PropertyHighlights, LocationDetails, PropertyDetails, SellerInformation
  - Bedrooms (double), Bathrooms (double), SquareFootage (double)
  - IsPropertyVisibleORM - publicly visible on site
  - IsPropertyActive - advertised/syndicated
  - SyndicateToZillow, IsPropertyRented
  - CompanyId (FK), OwnerId (FK to AspNetUsers)
  - BackgroundCheckFee, EnableBackgroundCheck
  - TransUnion fields: TuPropertyId, SaTuPropertyId, Classification, MinimumCreditScore, IR, ProductBundle, etc.
  - CurrentLeasePeriodId (FK), PropertyGroupId (FK)
  - DateCreated, LastUpdated, DateAdvertised, DateAdvertisedPaidNetworks
  - HideStreetAddress, IsFurnished, SmokingAllowed, IsRoomForRent
  - MerchantLocationId (FK - ProfitStars), SystemTransactionFee
  - LegalOwnerName, IsDeleted (soft delete)

  PropertyPhotos
  - Id, PropertyId (FK), PhotoUri, GalleryIndex, IsPrimaryPhoto, DateCreated

  PropertyListingTags
  - PropertyId (FK), ListingTagType (enum - amenities), Value (bigint)

  PropertyGroups
  - Id, Name, OwnerId (FK), CompanyId (FK), DateCreated

  PropertyNotes
  - Id, PropertyId (FK), ElectricalService, FurnaceFilterSize, Note
  - YearBuilt, YearAcquired, PurchasePrice

  PropertyNoteAppliances
  - Id, PropertyNoteId (FK), ApplianceName, Condition, SerialNumber, ModelNumber

  ---
  3. Lease Management

  LeasePeriods
  - Id (int, PK)
  - DateAvailable, StartDate, EndDate, LeaseName
  - PropertyId (FK)
  - LeaseDetails, LeaseType (enum: Fixed, MonthToMonth, Bidding)
  - MinimumPrice, RentItNowPrice, Deposit, Rent
  - IsDeleted, IsRentersInsuranceRequired

  LeaseTenants
  - Id, LeasePeriodId (FK), UserId (FK), PropertyBidAuthorizationId (FK)
  - Links tenants to lease periods

  ---
  4. Rental Applications

  RentalApplications
  - Id (int, PK)
  - FirstName, MiddleName, LastName, Email
  - SSN (int), DateOfBirth, MaritalStatus
  - DriverLicenseNo, DriverLicenseState
  - EmploymentStatus (enum), AssetValue
  - Screening questions: BeenSued, DeclaredBankruptcy, Felony, BrokenLease, SheriffLockout, BroughtToCourtPrevLandLord,
   MovedOwingDamageCompensation, TotalMoveInAmountAvailable, HasCosignerIfNeeded
  - TypedSignature, BackgroundCheckComments, BackgroundCheckAuthDate
  - LinkedInUsername, FacebookUsername, InstagramUsername, TwitterUsername
  - AdditionalNotes, User_Id (FK), DateSubmitted
  - DateSubmittedToTu, CanRunCreditAndBackgroundCheck, SaTuRenterId
  - IsDeleted, AssociateToApplicationId (FK - for group applications)

  RentalAddresses
  - Id, RentalApplicationId (FK)
  - StreetAddress, StreetAddressLineTwo, City, State, Zip
  - YearsAtLocation, IsCurrentLocation
  - LandlordName, LandlordPhone, ReasonForLeaving
  - AmountOfRent, RentPaymentUpToDate

  PhoneNumbers
  - Id, Number, PhoneType (enum), Extension
  - RentalApplicationId (FK), PersonalContactOfRenterId (FK)

  EmploymentRecords
  - Id, RentalApplicationId (FK)
  - Employer, Occupation, HoursPerWeek, Supervisor, Phone, PhoneExt
  - YearsEmployed, StreetAddress, City, State, Zip
  - Earnings, EarningsPeriod (enum), ActiveEmployment, StartDate, EndDate

  Incomes
  - Id, RentalApplicationId (FK)
  - IncomeAmount, Source, ProofOfIncome, IncomePeriod (enum)

  Pets
  - Id, RentalApplicationId (FK)
  - Name, TypeBreed, IsIndoorPet, Age

  Vehicles
  - Id, RentalApplicationId (FK)
  - Year, Make, Model, Color, PlateNo, State

  PersonalContactOfRenters
  - Id, FirstName, LastName, Relation
  - StreetAddress, City, State, Zip

  ApplicationGroups
  - Id, PropertyId (FK), LeasePeriodId (FK), DateCreated, IsDeleted

  ApplicationGroupMembers
  - Id, ApplicationGroupId (FK)
  - FirstName, LastName, Relation, Age, Occupation, Email
  - UserId (FK), ApplicationId (FK)
  - AcceptedInvitation, DateAcceptedInvitation
  - InvitationsSent, TimeLastInvitationSent
  - PropertyBidAuthorizationId (FK), IsDeleted

  ApplicationReviews
  - ApplicationId (FK, composite PK), ReviewerCompanyId (composite PK)
  - ReviewerId (FK), ReviewDate
  - ApplicationReviewType (enum: Pending, Approved, Denied)
  - ApplicationReviewNotes, IsDeleted

  ---
  5. Background Checks (TransUnion SmartMove)

  PropertyBidAuthorizations
  - Id (int, PK)
  - PropertyId (FK), PrimaryRenterId (FK), PrimaryApplicationId (FK)
  - TuApplicationId, SaTuScreeningRequestRenterId, SaTuScreeningRequestId
  - TuVerificationStatus (enum), TuVerificationStatusDate
  - TuApplicationStatus (enum), TuReportGenerationRequestDate
  - SaTuReportLastUpdatedByTuDate, DateSubmitted
  - ProductBundle (enum), CreditScoreRange (enum)
  - BackgroundCheckClear, EvictionCheckClear
  - DateTuReportLastRetrieved
  - LeasePeriodId (FK), ApplicationGroupId (FK), IsDeleted

  ---
  6. Bidding System

  Bids
  - Id, LeasePeriodId (FK), BidOwnerId (FK to AspNetUsers)
  - BidAmount, BidDate
  - AutoBidEnabled, BidMadeAutomatically, MaximumBid
  - IsDeleted

  ---
  7. Billing System

  AutoBillings - Recurring charges
  - Id, LeasePeriodId (FK)
  - BillingCategory (enum: Rent, Utilities, Pet, Parking, Other)
  - Amount, Description, DayOfMonthDue
  - LateFeesEnabled, DaysLateAssessFee, LateFeeAmount
  - AutoBillingStatus (enum), FrequencyInMonths
  - StartDate, EndDate, CreateNextBillingDate
  - DateCreated, DateUpdated, IpCreatedFrom
  - LastModifiedById (FK), IsDeleted

  Billings - Individual charges
  - Id, AutoBillingId (FK), LeasePeriodId (FK)
  - DateCreated, DateUpdated, IpCreatedFrom
  - CreatedBySystem, LastModifiedById (FK)
  - BillingCategory (enum), Description, Amount, DueDate
  - ServicePeriodStart, ServicePeriodEnd
  - LateFeesEnabled, LateFeeAmount, DaysLateAssessFee, LateAfterDate
  - IsLate, FullCorrectedAmount, IsDeleted

  BillingReferences
  - ReferenceId (PK), ParentBillingId (FK), ChildBillingId (FK)
  - BillingReferenceType (enum)
  - Links related billings (corrections, adjustments)

  ---
  8. Payment Processing

  BillingPayments - ACH payments via ProfitStars
  - Id, TransactionId (Guid, unique), LeasePeriodId (FK)
  - Amount, PaymentEffectiveDate, DateCreated, LastUpdated
  - PsBatchId (FK)
  - IsTransactionSystemFee, SystemFeeForBillingPaymentId (FK)
  - IpCreatedFrom, CreatedBySystem
  - PaidByUserId (FK), AuthorizedAsRecurring
  - AutoBillingPaymentId (FK)
  - ProfitStars fields: PsEntityId, PsLocationId, PsAccountReferenceId, PsTransactionReferenceId, PsResponseCode,
  PsResponseMessage, PsTransactionStatus, PsSettlementStatus, PsEffectiveDate
  - FundsAreScheduledOrSettled, PaymentFailure, PaymentFailureReason (enum)
  - NsfFeeStatus (enum), NsfFeeStatusDate

  BillingPaymentHistories
  - Id, BillingPaymentId (FK)
  - Audit trail of payment status changes

  BillingPaymentNsfCharges
  - BillingPaymentThatNSFdId (FK, PK), BillingPaymentNSFChargeId (FK)
  - Links failed payments to NSF fee charges

  AutoBillingPayments - Scheduled automatic payments
  - Id, LeasePeriodId (FK)
  - BillingCategory (enum), SplitType (enum: Amount or Percentage)
  - Amount, PayOnDayOfMonth, FrequencyInMonths
  - StartDate, EndDate, NextTransmitDate, NextEffectiveDate
  - IsEnabled, CreatedByUserId (FK), IsDeleted

  Payments - Braintree credit card payments (for application fees)
  - Id, Amount, PaymentReason (enum)
  - Success, TransactionStatus, StatusMessage, BraintreeTransactionId
  - RentalApplicationId (FK), DateCreated
  - FirstName, LastName, StreetAddress, Locality, Region, PostalCode
  - Refunded, PaidByUserId (FK), CreatedFromIp, UserAgentInfo

  ---
  9. Payment Methods

  CCPaymentMethods - Table Per Hierarchy (Discriminator column)
  - Id, Discriminator (string: 'LandlordCCPaymentMethod' or 'RenterCCPaymentMethod')
  - CreatedByUserId (FK), CompanyId (FK - landlord only)
  - DateCreated, DateUpdated, ExpirationDate
  - BillingFirstName, BillingLastName, BillingStreetAddress, BillingLocality, BillingRegion
  - CreatedFromIp, UserAgentInfo, Success
  - BraintreeCustomerId, BraintreePrimaryPaymentMethodId, StatusMessage
  - IsDeleted

  CustomerAccounts - ProfitStars bank accounts
  - UserId (FK, composite PK), EntityId (composite PK)
  - PsCustomerRegistered, CustomerNumber
  - BankInfoSet, PsAccountRegistered, AccountReferenceId, AccountName
  - IsRentMeCustomerAccount, IsDeleted

  ---
  10. ProfitStars ACH Integration

  MerchantLocations - Landlord ACH merchant accounts
  - Id, LocationId, EntityId, CompanyId (FK)
  - LocationName, DefaultMerchantTransactionFee, IsEnabled

  PsBatches - ACH payment batches
  - BatchId (bigint, PK - from ProfitStars)
  - BatchStatus, EffectiveDate, Description, Amount
  - EntityId, CompanyId (FK)

  PsBatchTransactions
  - Id, BatchId (FK), Amount, BatchDescription
  - EntryType, DisplayAccountNumber, AccountType
  - PsTransactionStatus, PsSettlementStatus
  - TransactionNumber, PsReferenceNumber, EffectiveDate
  - CustomerNumber, CustomerName, PropertyAddress
  - PropertyId (FK), LeasePeriodId (FK)

  PsApplicationEntities - Landlord ACH application tracking
  - Id, SubmissionResponseMessage, SubmittedSuccessfully
  - LandlordRentAppStatus (enum), ApplicationJson, ModelJson
  - SubmittedByUserId (FK), SubmittingUsersCompanyId (FK)
  - DateSubmitted, IpAddressSubmittedFrom
  - RequiresHigherLimits, TOSVersion, SubmittedToProcessor, IsDeleted

  ---
  11. Service Charges

  ServiceCharges - Table Per Hierarchy (Base class)
  - Id, Discriminator (string: 'SyndicationCharge' or 'PremiumServiceCharge')
  - CompanyId (FK), Amount, Description, ChargeDate
  - SyndicationCharge fields: StartAdvertiseProperty, EndAdvertiseProperty, StartChargePeriod, EndChargePeriod,
  PropertyId (FK), PaymentId (FK)

  ---
  12. Company Management

  LandlordCompanies
  - Id, CompanyName, OwnerUserId (FK)
  - CompanyType (enum: Individual, LLC, Corporation)
  - TaxId, Address, City, State, Zip
  - PhoneNumber, Email, Website, LogoUri
  - IsActive, DateCreated, AchSetupComplete

  LandlordCompanyPermissions
  - LandlordCompanyId (FK, composite PK), UserId (FK, composite PK)
  - Permission (enum: Owner, Manager, ReadOnly)
  - IsDeleted

  ---
  13. Leads & Showings

  Leads
  - Id, PropertyId (FK), UserId (FK)
  - FirstName, LastName, Email, PhoneNumber, Message
  - PreferredContactMethod (enum), ShowingDate
  - LeadStatus (enum: New, Contacted, Scheduled, Completed, Lost)
  - DateCreated, Source (enum: Website, Zillow, HotPads, Referral)

  ---
  14. Maintenance

  MaintenanceRequests
  - Id, LeasePeriodId (FK), PropertyId (FK)
  - TenantId (FK), LandlordId (FK)
  - Title, Description
  - Priority (enum: Low, Medium, High, Emergency)
  - Status (enum: Submitted, Acknowledged, InProgress, Completed, Cancelled)
  - Category (enum: Plumbing, Electrical, HVAC, Appliance, Other)
  - DateSubmitted, DateCompleted
  - EstimatedCost, ActualCost, Notes, IsDeleted

  MaintenanceRequestPhotos
  - Id, MaintenanceRequestId (FK), PhotoUri, DateUploaded, UploadedByUserId (FK)

  ---
  15. Insurance

  RentersInsurances
  - Id, RentersInsuranceType (enum), DatePurchasedSubmitted
  - RentersInsuranceDocumentId (FK)
  - AgreementId, SureStatusCode, SureStatusDate, PolicyNumber
  - TotalPremium, MonthlyPremium, PaymentFrequency (enum)
  - IncludePetDamage, IncludeWaterBackup, IncludeEarthquake, IncludeReplacementCost, IncludeIdentityFraud
  - PersonalPropertyCoverage, AllPerilDeductible, MedicalLimit, LiabilityLimit, HurricaneDeductible
  - UserId (FK), IsDeleted

  ---
  16. Documents

  AccountDocuments
  - Id, UserId (FK), DocumentType (enum)
  - DocumentUri, UploadDate, FileName, FileSize

  AccountDocumentRequests
  - Id, RequestedByUserId (FK), RequestedFromUserId (FK)
  - DocumentType (enum), RequestDate, DueDate, FulfilledDate
  - Status (enum), Notes

  AccountVerificationHistories
  - Id, UserId (FK), VerificationDate
  - VerificationType (enum), Status (enum), Details

  ---
  17. Notifications & Events

  SentNotifications
  - Id, NotificationDelivery (enum: Email, SMS)
  - NotificationReason (enum), UserId (FK)
  - LastSentDate, ExtraData

  LandlordEventRecords - Analytics tracking
  - EventRecordType (enum, composite PK), UserId (FK, composite PK)
  - UserEmail, LastLogin, LastUpdated
  - Boolean flags for milestone events: CreatedProperty, SubmittedBasicVerification, ApprovedBasicVerification,
  AdvertisedPropertyPaid, ReceivedApplication, HasTenant, UsedTenantCreditBackgroundScreening, etc.

  ---
  18. System Configuration

  SystemLimits
  - Id, LimitType (enum), MaxValue, ResetPeriod (enum), Description

  SystemLimitTallies
  - Id, SystemLimitId (FK), UserId (FK), CompanyId (FK)
  - CurrentValue, LastResetDate

  PhoneLookupInfos - Telnyx SMS carrier lookup
  - Id, PhoneNumber, CarrierName, PhoneNumberType, LastLookupDate

  ---
  Key Relationships

  AspNetUsers (1) ──< Properties (OwnerId)
  Properties (1) ──< LeasePeriods
  LeasePeriods (1) ──< LeaseTenants
  LeasePeriods (1) ──< Billings
  LeasePeriods (1) ──< BillingPayments
  LeasePeriods (1) ──< AutoBillings
  Properties (1) ──< RentalApplications
  RentalApplications (1) ──< PropertyBidAuthorizations
  PropertyBidAuthorizations (1) ──< ApplicationGroups
  LandlordCompanies (1) ──< Properties
  LandlordCompanies (1) ──< MerchantLocations
  BillingPayments (N) ──< PsBatches

  ---
  Database Design Patterns

  - Soft Deletes: Most entities implement ISoftDeletable with IsDeleted flag
  - Table Per Hierarchy: CCPaymentMethods, ServiceCharges
  - Audit Trails: DateCreated, DateUpdated, IpCreatedFrom, LastModifiedById
  - Self-referencing: Billings (corrections), RentalApplications (group applications)
  - Composite Keys: ApplicationReviews, CustomerAccounts, LandlordEventRecords
  - GUID Transaction IDs: BillingPayments.TransactionId for external tracking