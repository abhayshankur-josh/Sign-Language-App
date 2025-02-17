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

    private

    def create_reset_password_token(user)
        raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
        @token = raw
        user.reset_password_token = hashed
        user.reset_password_sent_at = Time.now.utc
        user.save
    end
end
