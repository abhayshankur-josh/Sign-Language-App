require 'rails_helper.rb'

RSpec.describe SubmissionQuery, type: :model do
  before do
    @approver = create(:user, :expert, email: "approver@gmail.com")
    @publisher = create(:user, :expert, email: "publisher@gmail.com")
    @sign = create(:sign)
    @submission = create(:submission)
  end

  subject { SubmissionQuery.instance }

  context "#attr_reader :submissions" do
    it "fetch all available records from Submission." do
      expect(subject.submissions).to match_array(Submission.all)
    end
  end

  context "when using #add_submission" do
    it "adds a valid submission record." do
      result = subject.add_submission(@publisher.id, @sign.id)
      expect {
        subject.add_submission(@publisher.id, @sign.id)
      }.to change(Submission, :count).by(1)
    end

    it "raises a exception when fails to add Submission." do
      expect {
        subject.add_submission(nil, @sign.id)
      }.to raise_error(Exception, "Validation failed: Submitted by can't be blank, Submitted by must exist")
    end

    it "raises a exception when fails to add Submission." do
      expect {
        subject.add_submission(@publisher.id, nil)
      }.to raise_error(Exception, "Validation failed: Sign can't be blank, Sign must exist")
    end

    it "raises a exception when fails to add Submission." do
      expect {
        subject.add_submission(456861, @sign.id)
      }.to raise_error(Exception, "Validation failed: Submitted by must exist")
    end

    it "raises a exception when fails to add Submission." do
      expect {
        subject.add_submission(@publisher.id, false)
      }.to raise_error(Exception, "Validation failed: Sign must exist")
    end
  end

  context "when using #update_approver?" do
    it "update a valid submission record." do
      result = subject.update_approver?(@submission.id, @approver.id)
      expect(result).to be true
    end

    it "raises a exception when fails to update Submission." do
      result = subject.update_approver?(nil, @approver.id)
      expect(result).to be false
    end

    it "raises a exception when fails to update Submission." do
      result = subject.update_approver?(@submission.id, nil)
      expect(result).to be false
    end

    it "raises a exception when fails to update Submission." do
      result = subject.update_approver?(515, @approver.id)
      expect(result).to be false
    end

    it "raises a exception when fails to update Submission." do
      result = subject.update_approver?(@submission.id, -56)
      expect(result).to be false
    end
  end
end
