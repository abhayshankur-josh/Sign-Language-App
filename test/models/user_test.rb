# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string
#  full_name  :string
#  password   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role_id    :integer
#
# Indexes
#
#  index_users_on_role_id  (role_id)
#
# Foreign Keys
#
#  role_id  (role_id => roles.id)
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
