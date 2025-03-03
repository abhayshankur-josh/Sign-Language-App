require 'rails_helper'

RSpec.describe Submissions::Action, type: :model do
  before do
    # TODO: to be done
  end

  describe "#call" do
    let(:submission_record) { create(:submission) }
    let(:sign_record) { create(:sign) }
    let(:approver_record) { create(:user, :expert) }

    let(:valid_params) do
      {
      submissionId: submission_record.id,
      signId: sign_record.id,
      approverId: approver_record.id,
      signStatus: :approved,
      rejectionReason: "Example Rejection Reason."
      }
    end

    subject { described_class.new(attributes).call }

    context "when attributes are valid" do
      let(:attributes) { valid_params }

      it "approves the submission successfully" do
        # expect { subject }.to modify(Submission)

        result = subject
        expect(result[:success]).to be true
        expect(result[:message]).to eq("Submission Action Successfull.")
      end
    end
  end
end
