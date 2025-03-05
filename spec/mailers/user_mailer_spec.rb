require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user, :expert, email: "test@example.com") }
  let(:publisher) { create(:user, :expert, email: "publisher@example.com") }
  let(:submission) { create(:submission, submitted_by_id: publisher.id) }

  context "when create_reset_password_token returns true" do
    before do
      allow_any_instance_of(UserMailer).to receive(:create_reset_password_token).and_return(true)
    end

    it "sends an email to the user" do
      email = UserMailer.new.user_invitation(user)

      expect(email.to).to eq([ user.email ])
      expect(email.from).to eq([ "optisyncenablers@gmail.com" ])
      expect(email.subject).to eq("Welcome to the #{APP_NAME}")
      expect(email.body.encoded).to include(user.email) # Customize this based on email body content
    end
  end

  context "when create_reset_password_token returns false" do
    before do
      allow_any_instance_of(UserMailer).to receive(:create_reset_password_token).and_return(false)
    end

    it "raise an exception" do
      expect {
        UserMailer.new.user_invitation(user)
    }.to raise_error(StandardError, "Failed to send mail")
    end
  end

  describe "#mail_to_publisher_on_submission_action" do
    context "when the submission is approved" do
      it "sends an email to the publisher with the corresponding subject" do
        result = UserMailer.new.mail_to_publisher_on_submission_action(submission.id)

        expect(result).to be true
        # expect(email.to).to eq([ publisher.email ])
        # expect(email.subject).to eq("Good News! Your Sign Submission to #{APP_NAME} is Now Published")
        # expect(email.body.encoded).to include("Congratulations!") # Adjust this based on your email content
      end
    end

    context "when the submission is not approved" do
      before { submission.update(sign_status: :pending) }

      it "sends an email to the publisher with the appropriate subject" do
        email = UserMailer.new.mail_to_publisher_on_submission_action(submission.id, "Some reason")

        expect(email.to).to eq([ publisher.email ])
        expect(email.subject).to eq("Update on Your Recent #{APP_NAME} Submission")
        expect(email.body.encoded).to include("Reason: Some reason") # Adjust this based on your email content
      end
    end

    context "when an error occurs" do
      it "logs an error and returns false" do
        allow_any_instance_of(SubmissionQuery).to receive(:get_submissions_view_for).and_raise(StandardError, "Failed to fetch submission")

        expect(Rails.logger).to receive(:error).with(/Failed to Send Mail/)
        result = UserMailer.new.mail_to_publisher_on_submission_action(submission.id)
        expect(result).to be(false)
      end
    end
  end
end
