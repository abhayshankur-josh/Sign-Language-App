require 'rails_helper'

RSpec.describe UserQuery, type: :model do
  before do
    create_list(:role, 3)
    create_list(:user, 2, :expert)
    create_list(:user, 2, :learner)
    create(:user, :admin, email: "admin@example.com")
    @role_name = RoleQuery::ROLE_USER
  end

  subject { UserQuery.instance }

  context "#attr_reader : users" do
    it "fetch all available records from User." do
      expect(subject.users).to match_array(User.all)
    end
  end

  context "when using #add_user!" do
    it "adds a valid user with the default role" do
      user = build(:user)
      expect { subject.add_user!(user) }.to change(User, :count).by(1)
    end

    it "raises an exception for an invalid user" do
      invalid_user = User.new(email: nil, full_name: nil, password: nil)
      expect {
        subject.add_user!(invalid_user, @role_name)
      }.to raise_error(Exception, /Email can't be blank, Password can't be blank, Full name can't be blank/)
    end
  end

  context "when using #create_user!" do
    let(:email) { "user@example.com" }
    let(:full_name) { "User" }
    let(:password) { "user@123" }

    it "adds a valid user with the default password" do
      expect {
        subject.create_user!(email, full_name, RoleQuery::ROLE_USER)
       }.to change(User, :count).by(1)
    end

    it "adds a valid user with provided password" do
      expect {
        subject.create_user!(email, full_name, RoleQuery::ROLE_USER, password)
       }.to change(User, :count).by(1)
    end

    it "raises an exception for an invalid user" do
      invalid_user = User.new(email: nil, full_name: nil)
      expect {
        subject.add_user!(invalid_user, @role_name)
      }.to raise_error(Exception, /Email can't be blank, Password can't be blank, Full name can't be blank/)
    end
  end

  context "when using #update_user?" do
    before do
      @user = User.create(
        email: Faker::Internet.email,
        full_name: Faker::Internet.username,
        password: Faker::Internet.password
      )
    end

    let(:valid_user_params) do
      {
        id: @user.id,
        full_name: Faker::Internet.username
        # password: Faker::Internet.password
      }
    end

    let(:invalid_user_params) do
      {
        id: 999999,
        full_name: Faker::Internet.username
        # password: Faker::Internet.password
      }
    end

    it "update a valid user with new full_name" do
      result = subject.update_user?(valid_user_params)
      expect(result).to be true
    end

    it "update an invalid user with new full_name" do
      result = subject.update_user?(invalid_user_params)
      expect(result).to be false
    end
  end

  context "when using #deactivate_user?" do
    let(:id) { create(:user, :learner).id }

    it "deactivate a valid user" do
      result = subject.deactivate_user?(id)
      expect(result).to be true
    end

    it "deactivate a non existing user" do
      result = subject.deactivate_user?(99999)
      expect(result).to be false
    end
  end

  context "when using #get_user_id" do
    let(:random_email) { User.pluck(:email).sample }

    it "if email exists" do
      result = subject.get_user_id(random_email)
      expect(result).to eq(User.find_by_email(random_email).id)
    end

    it "if email not exists" do
      result = subject.get_user_id("unknown@example.com")
      expect(result).to be nil
    end
  end
end
