# == Schema Information
#
# Table name: integrations
#
#  id          :bigint           not null, primary key
#  active      :boolean
#  description :text
#  logo        :string
#  name        :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Integration < ApplicationRecord
  # Associations
  has_many :application_connections, dependent: :destroy
  has_many :users, through: :application_connections
  
  # Validations
  validates :name, :slug, presence: true
  validates :slug, uniqueness: true
  
  # Scopes
  scope :active, -> { where(active: true) }
  
  # Class methods
  def self.google_calendar
    find_by(slug: 'google_calendar')
  end
  
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :integrations, partial: "integrations/index", locals: {integration: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :integrations, target: dom_id(self, :index) }
end
