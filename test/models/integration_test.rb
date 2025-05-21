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
require "test_helper"

class IntegrationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
