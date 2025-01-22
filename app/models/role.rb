# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  role_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Role < ApplicationRecord
  validates :role_name, uniqueness: true, presence: true
  has_many :user
end
