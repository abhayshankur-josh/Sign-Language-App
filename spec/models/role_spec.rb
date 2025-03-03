# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  role_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# spec/models/role_spec.rb
require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:role) { Role.create(role_name: 'Admin') }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(role).to be_valid
    end

    it 'is not valid without a role_name' do
      role.role_name = nil
      expect(role).not_to be_valid
    end

    it 'is not valid with a duplicate role_name' do
      Role.create(role_name: 'Admin')
      expect(role).not_to be_valid
    end
  end

  context 'associations' do
    it 'has many users' do
      expect(role).to respond_to(:users)
    end
  end

  context 'true and false conditions' do
    it 'returns true when role_name is present' do
      expect(role.role_name.present?).to eq(true)
    end

    it 'returns false when role_name is nil' do
      role.role_name = nil
      expect(role.role_name.present?).to eq(false)
    end

    it 'returns true when role has users' do
      user = User.create(email: 'test@example.com', full_name: 'Test User', role_id: role.id, password: 'password', password_confirmation: 'password')
      expect(role.users.any?).to eq(true)
    end

    it 'returns false when role does not have users' do
      expect(role.users.any?).to eq(false)
    end
  end
end
