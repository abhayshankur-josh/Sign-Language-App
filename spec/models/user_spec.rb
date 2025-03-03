# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  active                 :boolean          default(TRUE)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  full_name              :string
#  jti                    :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role_id                :integer          default(1)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#
# Foreign Keys
#
#  role_id  (role_id => roles.id)
#
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  # let(:role) { Role.create(role_name: 'Admin') }
  # let(:user) { User.new(email: 'test@example.com', full_name: 'Test User', role_id: role.id, password: 'password', password_confirmation: 'password') }

  # context 'validations' do
  #   it 'is valid with valid attributes' do
  #     expect(user).to be_valid
  #   end

  #   it 'is not valid without a full_name' do
  #     user.full_name = nil
  #     expect(user).not_to be_valid
  #   end

  #   it 'is not valid without a role_id' do
  #     user.role_id = nil
  #     expect(user).not_to be_valid
  #   end

  #   it 'is not valid without an email' do
  #     user.email = nil
  #     expect(user).not_to be_valid
  #   end

  #   it 'is not valid with a duplicate email' do
  #     User.create(email: 'test@example.com', full_name: 'Another User', role_id: role.id, password: 'password', password_confirmation: 'password')
  #     expect(user).not_to be_valid
  #   end

  #   it 'is not valid without a password' do
  #     user.password = nil
  #     expect(user).not_to be_valid
  #   end

  #   it 'is not valid with a short password' do
  #     user.password = user.password_confirmation = 'short'
  #     expect(user).not_to be_valid
  #   end

  #   it 'is not valid with an improperly formatted email' do
  #     user.email = 'invalid_email'
  #     expect(user).not_to be_valid
  #   end
  # end

  # context 'associations' do
  #   it 'belongs to a role' do
  #     expect(user).to belong_to(:role)
  #   end
  # end

  # context 'callbacks' do
  #   it 'sets jti before creation' do
  #     user.save
  #     expect(user.jti).not_to be_nil
  #   end
  # end

  # context 'database columns' do
  #   # it { should have_db_column(:email).of_type(:string) }
  #   # it { should have_db_column(:encrypted_password).of_type(:string) }
  #   # it { should have_db_column(:full_name).of_type(:string) }
  #   # it { should have_db_column(:jti).of_type(:string) }
  #   # it { should have_db_column(:remember_created_at).of_type(:datetime) }
  #   # it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
  #   # it { should have_db_column(:reset_password_token).of_type(:string) }
  #   # it { should have_db_column(:created_at).of_type(:datetime) }
  #   # it { should have_db_column(:updated_at).of_type(:datetime) }
  #   # it { should have_db_column(:role_id).of_type(:integer) }
  # end

  # context 'database indexes' do
  #   # it { should have_db_index(:email).unique(true) }
  #   # it { should have_db_index(:jti) }
  #   # it { should have_db_index(:reset_password_token).unique(true) }
  #   # it { should have_db_index(:role_id) }
  # end

  context 'associations' do
    it 'belongs to a role' do
      should belong_to(:role)
    end
  end

  context "validations" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end

    it "is invalid without a full_name" do
      user = build(:user, full_name: nil)
      expect(user).not_to be_valid
    end

    it "is invalid without an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with a duplicate email" do
      create(:user, email: "test@example.com")
      duplicate_user = build(:user, email: "test@example.com")
      expect(duplicate_user).not_to be_valid
    end

    it "is invalid without a password" do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it "is invalid without a role_id" do
      user = build(:user, role_id: nil)
      expect(user).not_to be_valid
    end
  end

  context 'methods' do
    it 'sets jti before creating a user' do
      user = build(:user)
      user.save
      expect(user.jti).not_to be_nil
    end
  end
end
