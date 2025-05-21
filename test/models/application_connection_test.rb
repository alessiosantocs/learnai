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
require "test_helper"

class ApplicationConnectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
