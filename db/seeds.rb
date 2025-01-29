# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seeding data for Role Table
Role.destroy_all

Role.create!([
  {
    id: 01,
    role_name: "user"
  },
  {
    id: 02,
    role_name: "expert"
  },
  {
    id: 03,
    role_name: "admin"
  }
])

p "Created #{Role.count} Roles."


# # Seeding data for User Table
# User.destroy_all

# User.create!([
#   {
#     full_name: "Admin Abhay",
#     email: "admin@gmail.com",
#     password: "abhay123",
#     role_id: 03
#   }
# ])

# p "Created #{User.count} Users."
