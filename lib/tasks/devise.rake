# lib/tasks/devise.rake
namespace :devise do
    desc "Send Invitation mail to new user."
    task user_invitation: :environment do
      User.in_batches(of: 10).each_record do |user|
        if user.role_id == 1
          # Send instructions so user can enter a new password:
          p UserMailer.user_invitation(user).deliver
          p user.id
        end
      end
    end
end
