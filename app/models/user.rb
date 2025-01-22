class User < ApplicationRecord
  validates :full_name, :email, :password, :role_id, presence: true
  validates :email, uniqueness: true
  belongs_to :role
end
