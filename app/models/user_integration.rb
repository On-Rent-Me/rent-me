class UserIntegration < ApplicationRecord
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
end
