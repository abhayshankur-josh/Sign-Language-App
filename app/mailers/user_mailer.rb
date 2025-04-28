# app/mailers/user_mailer.rb
class UserMailer < Devise::Mailer
    helper :application
    include Devise::Controllers::UrlHelpers
    default template_path: "devise/mailer"
    default from: "optisyncenablers@gmail.com"

    def user_invitation(user)
        @user = user
        if create_reset_password_token(user)
            mail_status = mail(to: @user.email, subject: "Welcome to the #{APP_NAME}")
        else
            raise StandardError.new("Failed to send mail")
        end
    end

    def mail_to_publisher_on_submission_action(submissionId, reason = nil)
        @submission = SubmissionQuery.instance.get_submissions_view_for(submissionId)
        @publisher = UserQuery.instance.get_user(@submission.publisher_id)
        @reason = reason
        subject = @submission.sign_status == :approved ? "Good News! Your Sign Submission to #{APP_NAME} is Now Published" : "Update on Your Recent #{APP_NAME} Submission"
        mail(to: @publisher.email, subject: subject)
        true
    rescue Exception => e
        Rails.logger.error "Failed to Send Mail: #{e.full_message}"
        false
    end

    private

    def create_reset_password_token(user)
        raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
        @token = raw
        user.reset_password_token = hashed
        user.reset_password_sent_at = Time.now.utc
        user.save
    end
end
