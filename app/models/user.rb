class User < ApplicationRecord
  validates :full_name, :password, :role_id, presence: true
  validates :email, uniqueness: true, presence: true
  belongs_to :role
end
