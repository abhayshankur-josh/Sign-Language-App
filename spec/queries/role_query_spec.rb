require 'rails_helper'

RSpec.describe RoleQuery, type: :model do
  before do
    create_list(:role, 3)
  end

  subject { RoleQuery.instance }

  context "#attr_reader : roles" do
    it "fetch all available records from Role." do
      expect(subject.roles).to match_array(Role.all)
    end
  end

  context "when get_admin_id" do
    it "returns the Role Id for admin" do
      expect(subject.get_admin_id).to eq(Role.find_by(role_name: RoleQuery::ROLE_ADMIN).id)
    end
  end

  context "when get_user_id" do
    it "returns the Role Id for learner" do
      expect(subject.get_user_id).to eq(Role.find_by(role_name: RoleQuery::ROLE_USER).id)
    end
  end

  context "when get_expert_id" do
    it "returns the Role Id for expert" do
      expect(subject.get_expert_id).to eq(Role.find_by(role_name: RoleQuery::ROLE_EXPERT).id)
    end
  end

  context "with get_role_name" do
    it "when role_name is admin" do
      expect(subject.get_role_name(1)).to eq(Role.find_by(role_name: RoleQuery::ROLE_EXPERT).role_name.humanize)
    end

    it "when role_name is admin" do
      expect(subject.get_role_name(2)).to eq(Role.find_by(role_name: RoleQuery::ROLE_USER).role_name.humanize)
    end

    it "when role_name is admin" do
      expect(subject.get_role_name(3)).to eq(Role.find_by(role_name: RoleQuery::ROLE_ADMIN).role_name.humanize)
    end
  end
end
