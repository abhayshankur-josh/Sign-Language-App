# == Schema Information
#
# Table name: submissions
#
#  id           :integer          not null, primary key
#  approved_by  :integer
#  submitted_by :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  sign_id      :integer
#
# Indexes
#
#  index_submissions_on_approved_by   (approved_by)
#  index_submissions_on_sign_id       (sign_id)
#  index_submissions_on_submitted_by  (submitted_by)
#
# Foreign Keys
#
#  approved_by   (approved_by => users.id)
#  sign_id       (sign_id => signs.id)
#  submitted_by  (submitted_by => users.id)
#
class Submission < ApplicationRecord
  validates :sign_id, :submitted_by, :approved_by, presence: true
  belongs_to :user, class_name: "user", foreign_key: "submitted_by"
  belongs_to :user, class_name: "user", foreign_key: "approved_by"
  belongs_to :sign, class_name: "sign", foreign_key: "sign_id"
end
