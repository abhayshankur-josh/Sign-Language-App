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
        result = subject
        expect(result[:success]).to be true
        expect(result[:message]).to eq("Submission Action Successfull.")
      end
    end

    context 'when update_status? fails' do
      let(:attributes) { valid_params }

      before do
        allow(SignQuery.instance).to receive(:update_status?).and_return(false)
      end

      it 'returns false and logs the error' do
        expect(subject).to eq({ success: false, message: 'Failed to Update Status!' })
      end
    end

    context 'when update_approver? fails' do
      let(:attributes) { valid_params }

      before do
        allow(SignQuery.instance).to receive(:update_status?).and_return(true)
        allow(SubmissionQuery.instance).to receive(:update_approver?).and_return(false)
      end

      it 'returns false and logs the error' do
        expect(subject).to eq({ success: false, message: 'Failed to Update Approver!' })
      end
    end

    context 'when send_mail? fails' do
      let(:attributes) { valid_params }

      before do
        allow(SignQuery.instance).to receive(:update_status?).and_return(true)
        allow(SubmissionQuery.instance).to receive(:update_approver?).and_return(true)
        allow(UserMailer).to receive_message_chain(:mail_to_publisher_on_submission_action, :deliver_now).and_return(false)
      end

      it 'raises an exception if mail sending fails' do
        expect(subject).to eq({ success: false, message: 'Failed to send Mail!' })
      end
    end

    # context "with send_maill?  " do
    #   let(:attributes) { valid_params }

    #   before do
    #     allow(SignQuery.instance).to receive(:update_status?).and_return(true)
    #     allow(SubmissionQuery.instance).to receive(:update_approver?).and_return(true)
    #     allow(UserMailer).to receive_message_chain(:mail_to_publisher_on_submission_action, :deliver_now).and_return(true)
    #   end

    #   it 'sends the mail successfully' do
    #     expect(subject).not_to raise_error
    #   end
    # end
  end
end
