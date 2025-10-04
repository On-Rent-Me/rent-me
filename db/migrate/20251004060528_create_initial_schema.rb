class CreateInitialSchema < ActiveRecord::Migration[8.0]
  def change
    # Enable PostgreSQL extensions
    enable_extension "plpgsql"
    enable_extension "pgcrypto"

    # ========================================
    # ASP.NET Identity Tables
    # ========================================

    create_table "asp_net_roles", id: false do |t|
      t.string :Id, limit: 128, primary_key: true
      t.string :Name, limit: 256
    end

    create_table "asp_net_users", id: false do |t|
      t.string :Id, limit: 128, primary_key: true
      t.string :Email, limit: 256
      t.boolean :EmailConfirmed, default: false, null: false
      t.string :PasswordHash
      t.string :SecurityStamp
      t.string :PhoneNumber
      t.boolean :PhoneNumberConfirmed, default: false, null: false
      t.boolean :TwoFactorEnabled, default: false, null: false
      t.datetime :LockoutEndDateUtc
      t.boolean :LockoutEnabled, default: false, null: false
      t.integer :AccessFailedCount, default: 0, null: false
      t.string :UserName, limit: 256, null: false

      # Custom RentMe fields
      t.integer :UserType, null: false
      t.string :FirstName
      t.string :LastName
      t.datetime :DateCreated, null: false
      t.uuid :AnalyticsId, null: false
      t.string :ReferralCode
      t.string :CreatedFromIp
      t.datetime :LastLoginDate
      t.integer :AccountVerificationMethod, null: false
      t.integer :AccountApprovalStatus, null: false
      t.integer :LoginCounter, default: 0, null: false
      t.boolean :IsDisabled, default: false, null: false
    end

    add_index "asp_net_users", :Email, name: "index_asp_net_users_on_email"
    add_index "asp_net_users", :UserName, name: "index_asp_net_users_on_user_name", unique: true
    add_index "asp_net_users", :AnalyticsId, name: "index_asp_net_users_on_analytics_id"

    create_table "asp_net_user_claims" do |t|
      t.string :UserId, limit: 128, null: false
      t.string :ClaimType
      t.string :ClaimValue
    end

    add_index "asp_net_user_claims", :UserId, name: "index_asp_net_user_claims_on_user_id"

    # Composite primary key table
    create_table "asp_net_user_logins", primary_key: [:LoginProvider, :ProviderKey, :UserId] do |t|
      t.string :LoginProvider, limit: 128, null: false
      t.string :ProviderKey, limit: 128, null: false
      t.string :UserId, limit: 128, null: false
    end

    add_index "asp_net_user_logins", :UserId, name: "index_asp_net_user_logins_on_user_id"

    # Composite primary key table
    create_table "asp_net_user_roles", primary_key: [:UserId, :RoleId] do |t|
      t.string :UserId, limit: 128, null: false
      t.string :RoleId, limit: 128, null: false
    end

    add_index "asp_net_user_roles", :RoleId, name: "index_asp_net_user_roles_on_role_id"
    add_index "asp_net_user_roles", :UserId, name: "index_asp_net_user_roles_on_user_id"

    # ========================================
    # Core Domain Tables
    # ========================================

    create_table "landlord_companies" do |t|
      t.integer :TuOrganizationId
      t.string :Name
      t.string :Phone
      t.string :PhoneExtension
      t.datetime :DateCreated, null: false
      t.string :CreatedByUserId
      t.string :StreetAddress
      t.string :StreetAddressLineTwo
      t.string :City
      t.string :State
      t.string :Zip
      t.boolean :ApprovedForAchPaymentProcessing, default: false, null: false
      t.decimal :SyndicationChargeFee, precision: 18, scale: 2
      t.boolean :IsDeleted, default: false, null: false
      t.integer :SaTuLandlordId
    end

    add_index "landlord_companies", :CreatedByUserId, name: "index_landlord_companies_on_created_by_user_id"

    create_table "property_groups" do |t|
      t.string :Name
    end

    create_table "merchant_locations" do |t|
      t.integer :LocationId, null: false
      t.integer :EntityId, null: false
      t.integer :CompanyId, null: false
      t.string :LocationName
      t.decimal :DefaultMerchantTransactionFee, precision: 18, scale: 2
      t.boolean :IsEnabled, default: true, null: false
    end

    add_index "merchant_locations", :CompanyId, name: "index_merchant_locations_on_company_id"

    create_table "lease_periods" do |t|
      t.datetime :DateAvailable, null: false
      t.datetime :StartDate, null: false
      t.datetime :EndDate
      t.string :LeaseName
      t.integer :PropertyId, null: false
      t.text :LeaseDetails
      t.integer :LeaseType, null: false
      t.decimal :MinimumPrice, precision: 18, scale: 2, null: false
      t.decimal :RentItNowPrice, precision: 18, scale: 2
      t.decimal :Deposit, precision: 18, scale: 2, null: false
      t.decimal :Rent, precision: 18, scale: 2, null: false
      t.boolean :IsDeleted, default: false, null: false
      t.boolean :IsRentersInsuranceRequired, default: false, null: false
    end

    add_index "lease_periods", :PropertyId, name: "index_lease_periods_on_property_id"

    create_table "properties" do |t|
      t.integer :TuPropertyId
      t.integer :SaTuPropertyId
      t.string :Name
      t.string :Address
      t.string :City
      t.integer :State, null: false
      t.string :Zip
      t.string :UnitNumber
      t.text :PropertyHighlights
      t.text :LocationDetails
      t.text :PropertyDetails
      t.text :SellerInformation
      t.float :Bathrooms, default: 0.0, null: false
      t.float :Bedrooms, default: 0.0, null: false
      t.float :SquareFootage, default: 0.0, null: false
      t.boolean :IsPropertyVisibleORM, default: false, null: false
      t.boolean :IsPropertyActive, default: false, null: false
      t.boolean :SyndicateToZillow, default: false, null: false
      t.boolean :IsPropertyRented, default: false, null: false
      t.integer :CompanyId
      t.string :OwnerId
      t.decimal :BackgroundCheckFee, precision: 18, scale: 2, default: "0.0", null: false
      t.boolean :EnableBackgroundCheck, default: false, null: false
      t.integer :Classification, null: false
      t.boolean :DeclineForOpenBankruptcies, default: false, null: false
      t.boolean :IncludeForeclosures, default: false, null: false
      t.boolean :IncludeMedicalCollections, default: false, null: false
      t.float :IR
      t.integer :OpenBankruptcyWindow
      t.integer :ProductBundle, null: false
      t.integer :MinimumCreditScore
      t.boolean :IsDeleted, default: false, null: false
      t.integer :CurrentLeasePeriodId
      t.integer :PropertyGroupId
      t.datetime :DateCreated, null: false
      t.datetime :LastUpdated, null: false
      t.datetime :DateAdvertised
      t.datetime :DateAdvertisedPaidNetworks
      t.boolean :HideStreetAddress, default: false, null: false
      t.boolean :IsFurnished, default: false, null: false
      t.boolean :SmokingAllowed, default: false, null: false
      t.integer :MerchantLocationId
      t.decimal :SystemTransactionFee, precision: 18, scale: 2
      t.boolean :IsRoomForRent, default: false, null: false
      t.string :LegalOwnerName
    end

    add_index "properties", :CompanyId, name: "index_properties_on_company_id"
    add_index "properties", :OwnerId, name: "index_properties_on_owner_id"
    add_index "properties", :CurrentLeasePeriodId, name: "index_properties_on_current_lease_period_id"
    add_index "properties", :PropertyGroupId, name: "index_properties_on_property_group_id"
    add_index "properties", :MerchantLocationId, name: "index_properties_on_merchant_location_id"

    # ========================================
    # Application & Rental Tables
    # ========================================

    create_table "personal_contact_of_renters" do |t|
      t.string :FirstName
      t.string :LastName
      t.string :Relation
      t.string :StreetAddress
      t.string :City
      t.string :State
      t.string :Zip
    end

    create_table "rental_applications" do |t|
      t.string :FirstName
      t.string :MiddleName
      t.string :LastName
      t.integer :SSN
      t.datetime :DateOfBirth
      t.string :MaritalStatus
      t.string :DriverLicenseNo
      t.string :DriverLicenseState
      t.string :Email
      t.integer :EmploymentStatus, null: false
      t.decimal :AssetValue, precision: 18, scale: 2
      t.boolean :BeenSued
      t.boolean :DeclaredBankruptcy
      t.boolean :Felony
      t.boolean :BrokenLease
      t.boolean :SheriffLockout
      t.boolean :BroughtToCourtPrevLandLord
      t.boolean :MovedOwingDamageCompensation
      t.boolean :TotalMoveInAmountAvailable
      t.string :TypedSignature
      t.boolean :HasCosignerIfNeeded
      t.text :BackgroundCheckComments
      t.datetime :BackgroundCheckAuthDate, null: false
      t.string :LinkedInUsername
      t.string :FacebookUsername
      t.string :InstagramUsername
      t.string :TwitterUsername
      t.text :AdditionalNotes
      t.string :User_Id
      t.datetime :DateSubmitted, null: false
      t.datetime :DateSubmittedToTu
      t.boolean :CanRunCreditAndBackgroundCheck, default: false, null: false
      t.integer :SaTuRenterId
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "rental_applications", :User_Id, name: "index_rental_applications_on_user_id"

    create_table "application_groups" do |t|
      t.integer :PropertyId, null: false
      t.integer :LeasePeriodId, null: false
      t.datetime :DateCreated, null: false
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "application_groups", :PropertyId, name: "index_application_groups_on_property_id"
    add_index "application_groups", :LeasePeriodId, name: "index_application_groups_on_lease_period_id"

    create_table "property_bid_authorizations" do |t|
      t.integer :PropertyId, null: false
      t.string :PrimaryRenterId, null: false
      t.integer :PrimaryApplicationId, null: false
      t.integer :TuApplicationId
      t.integer :SaTuScreeningRequestRenterId
      t.integer :SaTuScreeningRequestId
      t.integer :TuVerificationStatus
      t.datetime :TuVerificationStatusDate
      t.integer :TuApplicationStatus
      t.datetime :TuReportGenerationRequestDate
      t.datetime :SaTuReportLastUpdatedByTuDate
      t.datetime :DateSubmitted, null: false
      t.integer :ProductBundle
      t.integer :CreditScoreRange
      t.boolean :BackgroundCheckClear
      t.boolean :EvictionCheckClear
      t.datetime :DateTuReportLastRetrieved
      t.integer :LeasePeriodId
      t.integer :ApplicationGroupId
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "property_bid_authorizations", :PropertyId, name: "index_property_bid_authorizations_on_property_id"
    add_index "property_bid_authorizations", :PrimaryRenterId, name: "index_property_bid_authorizations_on_primary_renter_id"
    add_index "property_bid_authorizations", :PrimaryApplicationId, name: "index_property_bid_authorizations_on_primary_app_id"
    add_index "property_bid_authorizations", :LeasePeriodId, name: "index_property_bid_authorizations_on_lease_period_id"
    add_index "property_bid_authorizations", :ApplicationGroupId, name: "index_property_bid_authorizations_on_app_group_id"

    create_table "application_group_members" do |t|
      t.integer :ApplicationGroupId, null: false
      t.string :FirstName
      t.string :LastName
      t.string :Relation
      t.integer :Age, null: false
      t.string :Occupation
      t.string :Email
      t.string :UserId
      t.integer :ApplicationId
      t.boolean :AcceptedInvitation, default: false, null: false
      t.datetime :DateAcceptedInvitation
      t.integer :InvitationsSent, default: 0, null: false
      t.datetime :TimeLastInvitationSent
      t.integer :PropertyBidAuthorizationId
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "application_group_members", :ApplicationGroupId, name: "index_application_group_members_on_application_group_id"
    add_index "application_group_members", :UserId, name: "index_application_group_members_on_user_id"
    add_index "application_group_members", :ApplicationId, name: "index_application_group_members_on_application_id"
    add_index "application_group_members", :PropertyBidAuthorizationId, name: "index_application_group_members_on_pba_id"

    # Composite primary key table
    create_table "application_reviews", primary_key: [:ApplicationId, :ReviewerCompanyId] do |t|
      t.integer :ApplicationId, null: false
      t.string :ReviewerId
      t.integer :ReviewerCompanyId, null: false
      t.datetime :ReviewDate
      t.integer :ApplicationReviewType, null: false
      t.text :ApplicationReviewNotes
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "application_reviews", :ApplicationId, name: "index_application_reviews_on_application_id"
    add_index "application_reviews", :ReviewerId, name: "index_application_reviews_on_reviewer_id"

    create_table "employment_records" do |t|
      t.string :Employer
      t.string :Occupation
      t.integer :HoursPerWeek
      t.string :Supervisor
      t.string :Phone
      t.string :PhoneExt
      t.integer :YearsEmployed
      t.string :StreetAddress
      t.string :City
      t.string :State
      t.string :Zip
      t.integer :Earnings
      t.integer :EarningsPeriod
      t.boolean :ActiveEmployment
      t.integer :RentalApplicationId, null: false
      t.datetime :StartDate
      t.datetime :EndDate
    end

    add_index "employment_records", :RentalApplicationId, name: "index_employment_records_on_rental_application_id"

    create_table "incomes" do |t|
      t.decimal :IncomeAmount, precision: 18, scale: 2
      t.string :Source
      t.string :ProofOfIncome
      t.integer :IncomePeriod, null: false
      t.integer :RentalApplicationId, null: false
    end

    add_index "incomes", :RentalApplicationId, name: "index_incomes_on_rental_application_id"

    create_table "rental_addresses" do |t|
      t.string :StreetAddress
      t.string :StreetAddressLineTwo
      t.string :City
      t.string :State
      t.string :Zip
      t.float :YearsAtLocation
      t.boolean :IsCurrentLocation
      t.string :LandlordName
      t.string :LandlordPhone
      t.text :ReasonForLeaving
      t.decimal :AmountOfRent, precision: 18, scale: 2
      t.boolean :RentPaymentUpToDate
      t.integer :RentalApplicationId, null: false
    end

    add_index "rental_addresses", :RentalApplicationId, name: "index_rental_addresses_on_rental_application_id"

    create_table "pets" do |t|
      t.string :Name
      t.string :TypeBreed
      t.boolean :IsIndoorPet
      t.integer :Age
      t.integer :RentalApplicationId, null: false
    end

    add_index "pets", :RentalApplicationId, name: "index_pets_on_rental_application_id"

    create_table "vehicles" do |t|
      t.integer :Year
      t.string :Make
      t.string :Model
      t.string :Color
      t.string :PlateNo
      t.string :State
      t.integer :RentalApplicationId, null: false
    end

    add_index "vehicles", :RentalApplicationId, name: "index_vehicles_on_rental_application_id"

    create_table "phone_lookup_infos" do |t|
      t.datetime :DateLookupPerformed, null: false
      t.string :CountryCode
      t.string :NationalFormat
      t.string :PhoneNumber, limit: 30
      t.text :Fraud
      t.string :CarrierMobileCountryCode
      t.string :CarrierMobileNetworkCode
      t.string :CarrierName
      t.string :CarrierType
      t.string :CarrierErrorCode
      t.string :CNAMCallerName
      t.string :CNAMErrorCode
      t.string :PortabilityLRN
      t.string :PortabilityPortedStatus
      t.datetime :PortabilityPortedDate
      t.string :PortabilityOCN
      t.string :PortabilityLineType
      t.string :PortabilitySpid
      t.string :PortabilitySpidCarrierName
      t.string :PortabilitySpidCarrierType
      t.string :PortabilityAltSpid
      t.string :PortabilityAltSpidCarrierName
      t.string :PortabilityAltSpidCarrierType
      t.string :PortabilityCity
      t.string :PortabilityState
    end

    create_table "phone_numbers" do |t|
      t.string :Number
      t.integer :PhoneType
      t.string :Extension
      t.integer :RentalApplicationId, null: false
      t.integer :PersonalContactOfRenterId
    end

    add_index "phone_numbers", :RentalApplicationId, name: "index_phone_numbers_on_rental_application_id"
    add_index "phone_numbers", :PersonalContactOfRenterId, name: "index_phone_numbers_on_personal_contact_id"

    # ========================================
    # Bidding & Leasing Tables
    # ========================================

    create_table "bids" do |t|
      t.decimal :BidAmount, precision: 18, scale: 2, null: false
      t.boolean :AutoBidEnabled, default: false, null: false
      t.boolean :BidMadeAutomatically, default: false, null: false
      t.decimal :MaximumBid, precision: 18, scale: 2, null: false
      t.datetime :BidDate, null: false
      t.integer :PropertyId, null: false
      t.string :BidOwnerId
      t.boolean :IsDeleted, default: false, null: false
      t.integer :LeasePeriodId
      t.integer :PropertyBidAuthorizationId, null: false
      t.boolean :HideBid, default: false, null: false
    end

    add_index "bids", :PropertyId, name: "index_bids_on_property_id"
    add_index "bids", :BidOwnerId, name: "index_bids_on_bid_owner_id"
    add_index "bids", :LeasePeriodId, name: "index_bids_on_lease_period_id"

    create_table "account_documents" do |t|
      t.string :UserId, null: false
      t.integer :DocumentType, null: false
      t.integer :DocumentSpecificType, null: false
      t.integer :DocumentSide, null: false
      t.string :Name
      t.datetime :Created, null: false
      t.datetime :Modified, null: false
      t.string :Url
      t.integer :StorageLocation, null: false
      t.integer :Rotation, default: 0, null: false
      t.integer :Version, default: 0, null: false
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "account_documents", :UserId, name: "index_account_documents_on_user_id"

    create_table "renters_insurances" do |t|
      t.integer :RentersInsuranceType, null: false
      t.datetime :DatePurchasedSubmitted, null: false
      t.integer :RentersInsuranceDocumentId
      t.string :AgreementId
      t.string :SureStatusCode
      t.datetime :SureStatusDate
      t.string :PolicyNumber
      t.decimal :TotalPremium, precision: 18, scale: 2
      t.decimal :MonthlyPremium, precision: 18, scale: 2
      t.integer :PaymentFrequency
      t.boolean :IncludePetDamage
      t.boolean :IncludeWaterBackup
      t.boolean :IncludeEarthquake
      t.boolean :IncludeReplacementCost
      t.boolean :IncludeIdentityFraud
      t.decimal :PersonalPropertyCoverage, precision: 18, scale: 2
      t.decimal :AllPerilDeductible, precision: 18, scale: 2
      t.decimal :MedicalLimit, precision: 18, scale: 2
      t.decimal :LiabilityLimit, precision: 18, scale: 2
      t.decimal :HurricaneDeductible, precision: 18, scale: 2
      t.string :UserId
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "renters_insurances", :UserId, name: "index_renters_insurances_on_user_id"
    add_index "renters_insurances", :RentersInsuranceDocumentId, name: "index_renters_insurances_on_document_id"

    create_table "lease_tenants" do |t|
      t.integer :LeasePeriodId, null: false
      t.string :UserId
      t.integer :PropertyBidAuthorizationId
      t.string :FirstName
      t.string :LastName
      t.string :InviteEmail
      t.datetime :InvitationLastSent
      t.datetime :InsuranceSignupEmailLastSent
      t.boolean :LeaseAccepted
      t.datetime :LeaseAcceptedDate
      t.boolean :IsDeleted, default: false, null: false
      t.boolean :IsDisabled, default: false, null: false
      t.boolean :BankConfigured, default: false, null: false
      t.string :PhoneNumber
      t.boolean :HasRentersInsurance, default: false, null: false
      t.integer :RentersInsuranceId
    end

    add_index "lease_tenants", :LeasePeriodId, name: "index_lease_tenants_on_lease_period_id"
    add_index "lease_tenants", :UserId, name: "index_lease_tenants_on_user_id"
    add_index "lease_tenants", :PropertyBidAuthorizationId, name: "index_lease_tenants_on_pba_id"
    add_index "lease_tenants", :RentersInsuranceId, name: "index_lease_tenants_on_renters_insurance_id"

    # ========================================
    # Billing & Payment Tables
    # ========================================

    create_table "auto_billings" do |t|
      t.integer :LeasePeriodId, null: false
      t.integer :BillingCategory, null: false
      t.decimal :Amount, precision: 18, scale: 2
      t.string :Description
      t.integer :DayOfMonthDue, null: false
      t.boolean :LateFeesEnabled, default: false, null: false
      t.integer :DaysLateAssessFee
      t.decimal :LateFeeAmount, precision: 18, scale: 2
      t.integer :AutoBillingStatus, null: false
      t.integer :FrequencyInMonths, default: 1, null: false
      t.datetime :StartDate, null: false
      t.datetime :EndDate
      t.datetime :CreateNextBillingDate, null: false
      t.datetime :DateCreated, null: false
      t.datetime :DateUpdated, null: false
      t.string :IpCreatedFrom
      t.string :LastModifiedById
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "auto_billings", :LeasePeriodId, name: "index_auto_billings_on_lease_period_id"
    add_index "auto_billings", :LastModifiedById, name: "index_auto_billings_on_last_modified_by_id"

    create_table "billings" do |t|
      t.integer :AutoBillingId
      t.integer :LeasePeriodId, null: false
      t.datetime :DateCreated, null: false
      t.datetime :DateUpdated, null: false
      t.string :IpCreatedFrom
      t.boolean :CreatedBySystem, default: false, null: false
      t.string :LastModifiedById
      t.integer :BillingCategory, null: false
      t.text :Description
      t.decimal :Amount, precision: 18, scale: 2
      t.datetime :DueDate, null: false
      t.datetime :ServicePeriodStart
      t.datetime :ServicePeriodEnd
      t.boolean :LateFeesEnabled, default: false, null: false
      t.decimal :LateFeeAmount, precision: 18, scale: 2
      t.integer :DaysLateAssessFee
      t.datetime :LateAfterDate
      t.boolean :IsLate, default: false, null: false
      t.decimal :FullCorrectedAmount, precision: 18, scale: 2
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "billings", :AutoBillingId, name: "index_billings_on_auto_billing_id"
    add_index "billings", :LeasePeriodId, name: "index_billings_on_lease_period_id"
    add_index "billings", :LastModifiedById, name: "index_billings_on_last_modified_by_id"

    create_table "billing_references", id: false do |t|
      t.integer :ReferenceId, primary_key: true
      t.integer :ParentBillingId, null: false
      t.integer :BillingReferenceType, null: false
      t.integer :ChildBillingId, null: false
    end

    add_index "billing_references", [:ParentBillingId, :ChildBillingId], name: "IX_ParentChildBilling", unique: true

    create_table "auto_billing_payments" do |t|
      t.integer :LeasePeriodId, null: false
      t.integer :BillingCategory
      t.integer :SplitType, null: false
      t.decimal :Amount, precision: 18, scale: 2, null: false
      t.integer :PayOnDayOfMonth
      t.integer :FrequencyInMonths
      t.datetime :StartDate, null: false
      t.datetime :EndDate
      t.datetime :DateCreated, null: false
      t.datetime :NextTransmitDate, null: false
      t.datetime :NextEffectiveDate
      t.boolean :IsEnabled, default: true, null: false
      t.string :IpCreatedFrom
      t.string :CreatedByUserId
      t.datetime :DateDeleted
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "auto_billing_payments", :LeasePeriodId, name: "index_auto_billing_payments_on_lease_period_id"
    add_index "auto_billing_payments", :CreatedByUserId, name: "index_auto_billing_payments_on_created_by_user_id"

    create_table "billing_payments" do |t|
      t.uuid :TransactionId, null: false
      t.integer :LeasePeriodId, null: false
      t.decimal :Amount, precision: 18, scale: 2, null: false
      t.datetime :PaymentEffectiveDate, null: false
      t.datetime :DateCreated, null: false
      t.datetime :LastUpdated, null: false
      t.bigint :PsBatchId
      t.boolean :IsTransactionSystemFee, default: false, null: false
      t.integer :SystemFeeForBillingPaymentId
      t.string :IpCreatedFrom
      t.boolean :CreatedBySystem, default: false, null: false
      t.string :PaidByUserId
      t.boolean :AuthorizedAsRecurring, default: false, null: false
      t.integer :AutoBillingPaymentId
      t.integer :PsEntityId, null: false
      t.integer :PsLocationId, null: false
      t.string :PsAccountReferenceId
      t.string :PsTransactionReferenceId
      t.integer :PsResponseCode
      t.string :PsResponseMessage
      t.integer :PsTransactionStatus
      t.integer :PsSettlementStatus
      t.datetime :PsEffectiveDate
      t.boolean :FundsAreScheduledOrSettled, default: false, null: false
      t.boolean :PaymentFailure, default: false, null: false
      t.boolean :InitialPaymentAttemptFailed, default: false, null: false
      t.integer :PaymentFailureReason
      t.datetime :FailureDate
      t.integer :NsfFeeStatus, default: 0, null: false
      t.datetime :NsfFeeStatusDate
    end

    add_index "billing_payments", :TransactionId, name: "index_billing_payments_on_transaction_id", unique: true
    add_index "billing_payments", :LeasePeriodId, name: "index_billing_payments_on_lease_period_id"
    add_index "billing_payments", :PaidByUserId, name: "index_billing_payments_on_paid_by_user_id"
    add_index "billing_payments", :AutoBillingPaymentId, name: "index_billing_payments_on_auto_billing_payment_id"
    add_index "billing_payments", :SystemFeeForBillingPaymentId, name: "index_billing_payments_on_system_fee_for_id"

    create_table "billing_payment_histories" do |t|
      t.integer :BillingPaymentId, null: false
      t.decimal :Amount, precision: 18, scale: 2, null: false
      t.datetime :PaymentEffectiveDate, null: false
      t.datetime :DateHistoryCreated, null: false
      t.integer :PsEntityId, null: false
      t.integer :PsLocationId, null: false
      t.string :PsAccountReferenceId
      t.integer :PsResponseCode
      t.string :PsResponseMessage
      t.string :PsTransactionReferenceId
      t.integer :PsTransactionStatus
      t.integer :PsSettlementStatus
      t.datetime :PsEffectiveDate
      t.boolean :FundsAreScheduledOrSettled, default: false, null: false
      t.boolean :PaymentFailure, default: false, null: false
      t.integer :PaymentFailureReason
    end

    add_index "billing_payment_histories", :BillingPaymentId, name: "index_billing_payment_histories_on_billing_payment_id"

    create_table "billing_payment_nsf_charges", id: false do |t|
      t.integer :BillingPaymentThatNSFdId, primary_key: true
      t.integer :BillingPaymentNSFChargeId, null: false
    end

    add_index "billing_payment_nsf_charges", :BillingPaymentNSFChargeId, name: "index_billing_payment_nsf_charges_on_charge_id"

    create_table "payments" do |t|
      t.decimal :Amount, precision: 18, scale: 2, null: false
      t.integer :PaymentReason, null: false
      t.boolean :Success, default: false, null: false
      t.string :TransactionStatus
      t.text :StatusMessage
      t.string :BraintreeTransactionId
      t.integer :RentalApplicationId
      t.datetime :DateCreated, null: false
      t.string :FirstName
      t.string :LastName
      t.string :StreetAddress
      t.string :Locality
      t.string :Region
      t.string :PostalCode
      t.boolean :Refunded, default: false, null: false
      t.string :PaidByUserId
      t.string :CreatedFromIp
      t.text :UserAgentInfo
    end

    add_index "payments", :RentalApplicationId, name: "index_payments_on_rental_application_id"
    add_index "payments", :PaidByUserId, name: "index_payments_on_paid_by_user_id"

    # STI table for payment methods
    create_table "cc_payment_methods" do |t|
      t.string :type, null: false  # STI discriminator
      t.string :CreatedByUserId
      t.datetime :DateCreated, null: false
      t.datetime :DateUpdated, null: false
      t.datetime :ExpirationDate
      t.string :BillingFirstName
      t.string :BillingLastName
      t.string :BillingStreetAddress
      t.string :BillingLocality
      t.string :BillingRegion
      t.string :CreatedFromIp
      t.text :UserAgentInfo
      t.boolean :Success, default: false, null: false
      t.string :BraintreeCustomerId
      t.string :BraintreePrimaryPaymentMethodId
      t.text :StatusMessage
      t.boolean :IsDeleted, default: false, null: false
      t.integer :CompanyId  # For LandlordCCPaymentMethod
    end

    add_index "cc_payment_methods", :CreatedByUserId, name: "index_cc_payment_methods_on_created_by_user_id"
    add_index "cc_payment_methods", :CompanyId, name: "index_cc_payment_methods_on_company_id"
    add_index "cc_payment_methods", :type, name: "index_cc_payment_methods_on_type"

    # Composite primary key table
    create_table "customer_accounts", primary_key: [:UserId, :EntityId] do |t|
      t.string :UserId, null: false
      t.integer :EntityId, null: false
      t.boolean :PsCustomerRegistered, default: false, null: false
      t.string :CustomerNumber
      t.boolean :BankInfoSet, default: false, null: false
      t.boolean :PsAccountRegistered, default: false, null: false
      t.string :AccountReferenceId
      t.string :AccountName
      t.boolean :IsRentMeCustomerAccount, default: false, null: false
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "customer_accounts", :UserId, name: "index_customer_accounts_on_user_id"

    create_table "ps_batches", id: false do |t|
      t.bigint :BatchId, primary_key: true, null: false
      t.string :BatchStatus
      t.datetime :EffectiveDate, null: false
      t.text :Description
      t.decimal :Amount, precision: 18, scale: 2, null: false
      t.integer :EntityId, null: false
      t.integer :CompanyId
    end

    add_index "ps_batches", :CompanyId, name: "index_ps_batches_on_company_id"

    create_table "ps_batch_transactions" do |t|
      t.bigint :BatchId, null: false
      t.decimal :Amount, precision: 18, scale: 2, null: false
      t.text :BatchDescription
      t.string :EntryType
      t.string :DisplayAccountNumber
      t.string :AccountType
      t.integer :PsTransactionStatus
      t.integer :PsSettlementStatus
      t.string :TransactionNumber
      t.string :PsReferenceNumber
      t.datetime :EffectiveDate, null: false
      t.string :CustomerNumber
      t.string :CustomerName
      t.string :PropertyAddress
      t.integer :PropertyId
      t.integer :LeasePeriodId
    end

    add_index "ps_batch_transactions", :BatchId, name: "index_ps_batch_transactions_on_batch_id"
    add_index "ps_batch_transactions", :PropertyId, name: "index_ps_batch_transactions_on_property_id"
    add_index "ps_batch_transactions", :LeasePeriodId, name: "index_ps_batch_transactions_on_lease_period_id"

    create_table "ps_application_entities" do |t|
      t.text :SubmissionResponseMessage
      t.boolean :SubmittedSuccessfully, default: false, null: false
      t.integer :LandlordRentAppStatus, null: false
      t.text :ApplicationJson
      t.text :ModelJson
      t.string :SubmittedByUserId
      t.integer :SubmittingUsersCompanyId
      t.datetime :DateSubmitted, null: false
      t.string :IpAddressSubmittedFrom
      t.boolean :RequiresHigherLimits, default: false, null: false
      t.string :TOSVersion
      t.boolean :SubmittedToProcessor, default: false, null: false
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "ps_application_entities", :SubmittedByUserId, name: "index_ps_application_entities_on_submitted_by_user_id"
    add_index "ps_application_entities", :SubmittingUsersCompanyId, name: "index_ps_application_entities_on_company_id"

    # STI table for service charges
    create_table "service_charges" do |t|
      t.string :type, null: false  # STI discriminator for SyndicationCharge
      t.datetime :ChargeDate
      t.boolean :IsCharged, default: false, null: false
      t.decimal :Amount, precision: 18, scale: 2
      t.integer :CompanyId  # For LandlordServiceCharge descendants
      t.datetime :StartAdvertiseProperty  # For SyndicationCharge
      t.datetime :EndAdvertiseProperty  # For SyndicationCharge
      t.datetime :StartChargePeriod  # For SyndicationCharge
      t.datetime :EndChargePeriod  # For SyndicationCharge
      t.integer :PropertyId  # For SyndicationCharge
      t.integer :PaymentId  # For SyndicationCharge
    end

    add_index "service_charges", :type, name: "index_service_charges_on_type"
    add_index "service_charges", :CompanyId, name: "index_service_charges_on_company_id"
    add_index "service_charges", :PropertyId, name: "index_service_charges_on_property_id"
    add_index "service_charges", :PaymentId, name: "index_service_charges_on_payment_id"

    # ========================================
    # Property & Account Management Tables
    # ========================================

    create_table "property_photos" do |t|
      t.string :Name
      t.datetime :Created, null: false
      t.bigint :Size, default: 0, null: false
      t.string :Url
      t.integer :StorageLocation, null: false
      t.text :Description
      t.integer :PropertyId, null: false
      t.integer :GalleryIndex, default: 0, null: false
      t.integer :Rotation, default: 0, null: false
      t.integer :Version, default: 0, null: false
    end

    add_index "property_photos", :PropertyId, name: "index_property_photos_on_property_id"

    create_table "property_notes" do |t|
      t.integer :PropertyId, null: false
      t.string :ElectricalService
      t.string :FurnaceFilterSize
      t.text :Note
      t.integer :YearBuilt, default: 0, null: false
      t.integer :YearAcquired, default: 0, null: false
      t.decimal :PurchasePrice, precision: 18, scale: 2, default: "0.0", null: false
      t.datetime :DateCreated, null: false
      t.datetime :DateUpdated, null: false
    end

    add_index "property_notes", :PropertyId, name: "index_property_notes_on_property_id"

    create_table "property_note_appliances" do |t|
      t.integer :PropertyNoteId, null: false
      t.integer :ApplianceType, null: false
      t.string :Make
      t.string :Model
      t.text :Note
    end

    add_index "property_note_appliances", :PropertyNoteId, name: "index_property_note_appliances_on_property_note_id"

    # Composite primary key table
    create_table "property_listing_tags", primary_key: [:PropertyId, :ListingTagType] do |t|
      t.integer :PropertyId, null: false
      t.integer :ListingTagType, null: false
      t.bigint :Value, default: 0, null: false
    end

    create_table "account_document_requests" do |t|
      t.string :UserId, null: false
      t.integer :CompanyId, null: false
      t.integer :DocumentType, null: false
      t.integer :DocumentSpecificType, null: false
      t.boolean :isUploaded, default: false, null: false
      t.integer :DocumentId
      t.datetime :DateRequested, null: false
      t.datetime :DateUploaded
      t.string :RequestDetail
      t.string :RequestedById
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "account_document_requests", :UserId, name: "index_account_document_requests_on_user_id"
    add_index "account_document_requests", :CompanyId, name: "index_account_document_requests_on_company_id"
    add_index "account_document_requests", :DocumentId, name: "index_account_document_requests_on_document_id"
    add_index "account_document_requests", :RequestedById, name: "index_account_document_requests_on_requested_by_id"

    create_table "account_verification_histories" do |t|
      t.string :UserId, null: false
      t.integer :AccountVerificationMethod, null: false
      t.integer :AccountApprovalStatus, null: false
      t.datetime :DateCreated, null: false
      t.string :EntryCreatedByUserId
      t.text :Note
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "account_verification_histories", :UserId, name: "index_account_verification_histories_on_user_id"
    add_index "account_verification_histories", :EntryCreatedByUserId, name: "index_account_verification_histories_on_entry_created_by"

    create_table "landlord_company_permissions", id: false do |t|
      t.string :UserId, limit: 128, primary_key: true, null: false
      t.integer :LandlordCompanyId, null: false
      t.integer :Permission, null: false
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "landlord_company_permissions", :LandlordCompanyId, name: "index_landlord_company_permissions_on_company_id"

    # Composite primary key table
    create_table "landlord_event_records", primary_key: [:EventRecordType, :UserId] do |t|
      t.integer :EventRecordType, null: false
      t.string :UserId, null: false
      t.string :UserEmail
      t.datetime :LastLogin, null: false
      t.datetime :LastUpdated, null: false
      t.boolean :CreatedProperty, default: false, null: false
      t.boolean :SubmittedBasicVerification, default: false, null: false
      t.boolean :ApprovedBasicVerification, default: false, null: false
      t.boolean :SubmittedACHVerification, default: false, null: false
      t.boolean :ApprovedACHVerification, default: false, null: false
      t.boolean :AdvertisedPropertyPaid, default: false, null: false
      t.boolean :AdvertisedPropertyFree, default: false, null: false
      t.boolean :ReceivedApplication, default: false, null: false
      t.boolean :HasTenant, default: false, null: false
      t.boolean :UsedTenantCreditBackgroundScreening, default: false, null: false
      t.boolean :TenantsUseRentersInsurance, default: false, null: false
      t.boolean :HasMaintenanceRequest, default: false, null: false
      t.boolean :GeneratedCreditBackgroundRevenue, default: false, null: false
      t.boolean :GeneratedACHRevenue, default: false, null: false
      t.boolean :GeneratedRentersInsuranceRevenue, default: false, null: false
    end

    # ========================================
    # Maintenance & Leads Tables
    # ========================================

    create_table "maintenance_requests" do |t|
      t.text :Description
      t.boolean :Urgent, default: false, null: false
      t.boolean :ActiveDamageOrSafetyThreat, default: false, null: false
      t.integer :Category, null: false
      t.integer :Status, null: false
      t.datetime :DateCreated, null: false
      t.datetime :LastUpdated, null: false
      t.string :CreatedByUserId
      t.integer :LeasePeriodId, null: false
      t.text :LandlordNote
      t.boolean :LandlordNoteVisibleToTenant, default: false, null: false
      t.decimal :EstimatedCost, precision: 18, scale: 2
      t.datetime :MaintenanceDate
      t.datetime :MaintenanceEndDate
      t.boolean :MaintenanceReminderEnabled, default: false, null: false
      t.string :NotificationTimeZoneOffset
      t.string :LandlordLocalTimeZone
      t.text :ReminderNote
      t.decimal :ActualCost, precision: 18, scale: 2
      t.string :TechnicianEmail
      t.boolean :TenantAvailableToOpenDoor
      t.string :TenantNameWhoResponded
      t.datetime :TenantAvailableResponseDate
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "maintenance_requests", :LeasePeriodId, name: "index_maintenance_requests_on_lease_period_id"
    add_index "maintenance_requests", :CreatedByUserId, name: "index_maintenance_requests_on_created_by_user_id"

    create_table "maintenance_request_photos" do |t|
      t.integer :Index, default: 0, null: false
      t.string :Name
      t.string :Url
      t.integer :StorageLocation, null: false
      t.integer :MaintenanceRequestId, null: false
    end

    add_index "maintenance_request_photos", :MaintenanceRequestId, name: "index_maintenance_request_photos_on_request_id"

    create_table "leads" do |t|
      t.integer :PropertyId
      t.integer :CompanyId
      t.integer :LeadSource, null: false
      t.integer :LeadStatus, null: false
      t.text :Note
      t.datetime :ShowingDate
      t.datetime :DateReviewed
      t.datetime :DateCreated, null: false
      t.datetime :DateLastUpdated, null: false
      t.boolean :ShowingNotificationEnabled, default: false, null: false
      t.boolean :ShowingReminderSent, default: false, null: false
      t.datetime :DateShowingNotificationSent
      t.integer :NotificationTimeZoneOffset, default: 0, null: false
      t.datetime :DateApplicationInvitationSent
      t.string :UserId
      t.string :Name
      t.string :Email
      t.string :Phone
      t.datetime :MovingDate
      t.text :PetDetailsJson
      t.boolean :Smoker
      t.integer :CreditRangeLow
      t.integer :CreditRangeHigh
      t.integer :IncomeYearly
      t.text :ReasonForMoving
      t.integer :LeaseLengthMonths
      t.string :JobTitle
      t.string :Employer
      t.datetime :EmploymentStartDate
      t.text :PreviousEmployerJson
      t.text :Introduction
      t.text :Message
      t.text :RawLeadPostData
      t.boolean :IsDeleted, default: false, null: false
    end

    add_index "leads", :PropertyId, name: "index_leads_on_property_id"
    add_index "leads", :UserId, name: "index_leads_on_user_id"

    # ========================================
    # System & Notification Tables
    # ========================================

    create_table "sent_notifications" do |t|
      t.integer :NotificationDelivery, null: false
      t.integer :NotificationReason, null: false
      t.string :UserId
      t.datetime :LastSentDate, null: false
      t.text :ExtraData
    end

    add_index "sent_notifications", :UserId, name: "index_sent_notifications_on_user_id"

    create_table "system_limits", id: false do |t|
      t.integer :LimitType, primary_key: true, null: false
      t.integer :Limit, null: false
    end

    create_table "system_limit_tallies" do |t|
      t.integer :LimitType, null: false
      t.datetime :TimePeriodStart, null: false
      t.integer :Tally, default: 0, null: false
    end

    add_index "system_limit_tallies", :LimitType, name: "index_system_limit_tallies_on_limit_type"

    # ========================================
    # Foreign Key Constraints
    # ========================================

    add_foreign_key "account_document_requests", "asp_net_users", column: "UserId", primary_key: "Id"
    add_foreign_key "account_document_requests", "landlord_companies", column: "CompanyId"
    add_foreign_key "account_document_requests", "account_documents", column: "DocumentId"
    add_foreign_key "account_document_requests", "asp_net_users", column: "RequestedById", primary_key: "Id"

    add_foreign_key "account_documents", "asp_net_users", column: "UserId", primary_key: "Id"

    add_foreign_key "account_verification_histories", "asp_net_users", column: "UserId", primary_key: "Id"
    add_foreign_key "account_verification_histories", "asp_net_users", column: "EntryCreatedByUserId", primary_key: "Id"

    add_foreign_key "application_group_members", "application_groups", column: "ApplicationGroupId"
    add_foreign_key "application_group_members", "asp_net_users", column: "UserId", primary_key: "Id"
    add_foreign_key "application_group_members", "rental_applications", column: "ApplicationId"
    add_foreign_key "application_group_members", "property_bid_authorizations", column: "PropertyBidAuthorizationId"

    add_foreign_key "application_groups", "properties", column: "PropertyId"
    add_foreign_key "application_groups", "lease_periods", column: "LeasePeriodId"

    add_foreign_key "application_reviews", "rental_applications", column: "ApplicationId"
    add_foreign_key "application_reviews", "asp_net_users", column: "ReviewerId", primary_key: "Id"

    add_foreign_key "auto_billing_payments", "lease_periods", column: "LeasePeriodId"
    add_foreign_key "auto_billing_payments", "asp_net_users", column: "CreatedByUserId", primary_key: "Id"

    add_foreign_key "auto_billings", "lease_periods", column: "LeasePeriodId"
    add_foreign_key "auto_billings", "asp_net_users", column: "LastModifiedById", primary_key: "Id"

    add_foreign_key "bids", "properties", column: "PropertyId"
    add_foreign_key "bids", "asp_net_users", column: "BidOwnerId", primary_key: "Id"
    add_foreign_key "bids", "lease_periods", column: "LeasePeriodId"

    add_foreign_key "billing_payment_histories", "billing_payments", column: "BillingPaymentId"

    add_foreign_key "billing_payment_nsf_charges", "billing_payments", column: "BillingPaymentThatNSFdId", primary_key: "id"
    add_foreign_key "billing_payment_nsf_charges", "billing_payments", column: "BillingPaymentNSFChargeId", primary_key: "id"

    add_foreign_key "billing_payments", "lease_periods", column: "LeasePeriodId"
    add_foreign_key "billing_payments", "asp_net_users", column: "PaidByUserId", primary_key: "Id"
    add_foreign_key "billing_payments", "auto_billing_payments", column: "AutoBillingPaymentId"
    add_foreign_key "billing_payments", "billing_payments", column: "SystemFeeForBillingPaymentId", primary_key: "id"

    add_foreign_key "billing_references", "billings", column: "ParentBillingId", primary_key: "id"
    add_foreign_key "billing_references", "billings", column: "ChildBillingId", primary_key: "id"

    add_foreign_key "billings", "auto_billings", column: "AutoBillingId"
    add_foreign_key "billings", "lease_periods", column: "LeasePeriodId"
    add_foreign_key "billings", "asp_net_users", column: "LastModifiedById", primary_key: "Id"

    add_foreign_key "cc_payment_methods", "asp_net_users", column: "CreatedByUserId", primary_key: "Id"
    add_foreign_key "cc_payment_methods", "landlord_companies", column: "CompanyId"

    add_foreign_key "customer_accounts", "asp_net_users", column: "UserId", primary_key: "Id"

    add_foreign_key "employment_records", "rental_applications", column: "RentalApplicationId"

    add_foreign_key "incomes", "rental_applications", column: "RentalApplicationId"

    add_foreign_key "landlord_companies", "asp_net_users", column: "CreatedByUserId", primary_key: "Id"

    add_foreign_key "landlord_company_permissions", "landlord_companies", column: "LandlordCompanyId"
    add_foreign_key "landlord_company_permissions", "asp_net_users", column: "UserId", primary_key: "Id"

    add_foreign_key "landlord_event_records", "asp_net_users", column: "UserId", primary_key: "Id"

    add_foreign_key "leads", "properties", column: "PropertyId"
    add_foreign_key "leads", "asp_net_users", column: "UserId", primary_key: "Id"

    add_foreign_key "lease_periods", "properties", column: "PropertyId"

    add_foreign_key "lease_tenants", "lease_periods", column: "LeasePeriodId"
    add_foreign_key "lease_tenants", "asp_net_users", column: "UserId", primary_key: "Id"
    add_foreign_key "lease_tenants", "property_bid_authorizations", column: "PropertyBidAuthorizationId"
    add_foreign_key "lease_tenants", "renters_insurances", column: "RentersInsuranceId"

    add_foreign_key "maintenance_request_photos", "maintenance_requests", column: "MaintenanceRequestId"

    add_foreign_key "maintenance_requests", "lease_periods", column: "LeasePeriodId"
    add_foreign_key "maintenance_requests", "asp_net_users", column: "CreatedByUserId", primary_key: "Id"

    add_foreign_key "merchant_locations", "landlord_companies", column: "CompanyId"

    add_foreign_key "payments", "rental_applications", column: "RentalApplicationId"
    add_foreign_key "payments", "asp_net_users", column: "PaidByUserId", primary_key: "Id"

    add_foreign_key "phone_numbers", "rental_applications", column: "RentalApplicationId"
    add_foreign_key "phone_numbers", "personal_contact_of_renters", column: "PersonalContactOfRenterId"

    add_foreign_key "properties", "landlord_companies", column: "CompanyId"
    add_foreign_key "properties", "asp_net_users", column: "OwnerId", primary_key: "Id"
    add_foreign_key "properties", "lease_periods", column: "CurrentLeasePeriodId"
    add_foreign_key "properties", "property_groups", column: "PropertyGroupId"
    add_foreign_key "properties", "merchant_locations", column: "MerchantLocationId"

    add_foreign_key "property_bid_authorizations", "properties", column: "PropertyId"
    add_foreign_key "property_bid_authorizations", "asp_net_users", column: "PrimaryRenterId", primary_key: "Id"
    add_foreign_key "property_bid_authorizations", "rental_applications", column: "PrimaryApplicationId"
    add_foreign_key "property_bid_authorizations", "lease_periods", column: "LeasePeriodId"
    add_foreign_key "property_bid_authorizations", "application_groups", column: "ApplicationGroupId"

    add_foreign_key "property_listing_tags", "properties", column: "PropertyId"

    add_foreign_key "property_note_appliances", "property_notes", column: "PropertyNoteId"

    add_foreign_key "property_notes", "properties", column: "PropertyId"

    add_foreign_key "property_photos", "properties", column: "PropertyId"

    add_foreign_key "ps_application_entities", "asp_net_users", column: "SubmittedByUserId", primary_key: "Id"
    add_foreign_key "ps_application_entities", "landlord_companies", column: "SubmittingUsersCompanyId"

    add_foreign_key "ps_batch_transactions", "ps_batches", column: "BatchId", primary_key: "BatchId"
    add_foreign_key "ps_batch_transactions", "properties", column: "PropertyId"
    add_foreign_key "ps_batch_transactions", "lease_periods", column: "LeasePeriodId"

    add_foreign_key "ps_batches", "landlord_companies", column: "CompanyId"

    add_foreign_key "rental_addresses", "rental_applications", column: "RentalApplicationId"

    add_foreign_key "rental_applications", "asp_net_users", column: "User_Id", primary_key: "Id"

    add_foreign_key "renters_insurances", "asp_net_users", column: "UserId", primary_key: "Id"
    add_foreign_key "renters_insurances", "account_documents", column: "RentersInsuranceDocumentId"

    add_foreign_key "service_charges", "landlord_companies", column: "CompanyId"
    add_foreign_key "service_charges", "properties", column: "PropertyId"
    add_foreign_key "service_charges", "payments", column: "PaymentId"

    add_foreign_key "vehicles", "rental_applications", column: "RentalApplicationId"
  end
end
