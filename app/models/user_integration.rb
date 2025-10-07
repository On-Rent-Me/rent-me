class UserIntegration < ApplicationRecord
  extend FriendlyId
  friendly_id :integration_name, use: [:slugged, :history]

  belongs_to :user

  validates :integration_type, presence: true
  validates :integration_type, uniqueness: { scope: :user_id }

  scope :active, -> { where(active: true) }
  scope :by_type, ->(type) { where(integration_type: type) }

  def expired?
    expires_at && expires_at < Time.current
  end

  def needs_refresh?
    expired? && refresh_token.present?
  end

  # Method to generate slug from integration name
  def integration_name
    "#{integration_type}-#{user_id}"
  end

  # Override should_generate_new_friendly_id? to regenerate slug when integration_type changes
  def should_generate_new_friendly_id?
    integration_type_changed? || super
  end
end
