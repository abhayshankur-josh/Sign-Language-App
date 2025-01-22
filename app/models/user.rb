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
class User < ApplicationRecord
  validates :full_name, :email, :password, :role_id, presence: true
  validates :email, uniqueness: true
  belongs_to :role
end
