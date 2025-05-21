# == Schema Information
#
# Table name: application_connections
#
#  id             :bigint           not null, primary key
#  active         :boolean
#  metadata       :jsonb
#  name           :string
#  settings       :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  integration_id :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_application_connections_on_integration_id  (integration_id)
#  index_application_connections_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (integration_id => integrations.id)
#  fk_rails_...  (user_id => users.id)
#
class ApplicationConnection < ApplicationRecord
  belongs_to :user
  belongs_to :integration
  
  # Validations
  validates :integration_id, uniqueness: { scope: :user_id, message: "is already connected" }
  
  # Scopes
  scope :active, -> { where(active: true) }
  
  # Delegation methods to access OAuth tokens via connected_account
  delegate :access_token, :refresh_token, :expires_at, to: :connected_account, allow_nil: true
  
  # Find or create the associated ConnectedAccount
  def connected_account
    return nil unless integration.slug.include?("google")
    
    user.connected_accounts.google_oauth2.first
  end
  
  def expired?
    expires_at? && expires_at <= Time.current
  end
  
  def active_and_valid?
    active? && connected_account.present? && !expired?
  end
  
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :application_connections, partial: "application_connections/index", locals: {application_connection: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :application_connections, target: dom_id(self, :index) }
end
