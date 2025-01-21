class Role < ApplicationRecord
  validates :role_name, uniqueness: true, presence: true
  has_many :user
end
