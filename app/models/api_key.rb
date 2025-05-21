# == Schema Information
#
# Table name: api_keys
#
#  id           :bigint           not null, primary key
#  active       :boolean
#  last_used_at :datetime
#  name         :string
#  token        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_api_keys_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class ApiKey < ApplicationRecord
  belongs_to :user
  
  validates :token, presence: true, uniqueness: true
  validates :name, presence: true
  
  before_validation :generate_token, on: :create
  
  scope :active, -> { where(active: true) }
  
  def self.generate_unique_token
    SecureRandom.urlsafe_base64(32)
  end
  
  def touch_last_used
    update_column(:last_used_at, Time.current)
  end
  
  private
  
  def generate_token
    self.token = self.class.generate_unique_token
  end
  
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :api_keys, partial: "api_keys/index", locals: {api_key: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :api_keys, target: dom_id(self, :index) }
end
