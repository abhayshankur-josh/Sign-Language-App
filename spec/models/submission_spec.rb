# spec/models/submission_spec.rb
require 'rails_helper'

RSpec.describe Submission, type: :model do
  context "associations" do
    it "belongs to a sign" do
      should belong_to(:sign).class_name('Sign').with_foreign_key('sign_id')
    end

    it "belongs to a user for submittrd_by" do
      should belong_to(:submitted_by).class_name('User').with_foreign_key('submitted_by_id')
    end

    it "belongs to a user for approved_by" do
      should belong_to(:approved_by).class_name('User').with_foreign_key('approved_by_id').optional
    end
  end

  context "validations" do
    it "has a valid factory" do
      expect(build(:submission)).to be_valid
    end

    it "is invalid without a sign_id" do
      submission = build(:submission, sign_id: nil)
      expect(submission).not_to be_valid
    end

    it "is invalid without a submitted_by_id" do
      submission = build(:submission, submitted_by_id: nil)
      expect(submission).not_to be_valid
    end

    it "is valid without an approved_by_id" do
      submission = build(:submission, approved_by_id: nil)
      expect(submission).to be_valid
    end

    it "is valid with an approved_by_id using the :approved trait" do
      submission = build(:submission, :approved)
      expect(submission).to be_valid
    end
  end
end
