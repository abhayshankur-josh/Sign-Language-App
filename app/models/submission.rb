# == Schema Information
#
# Table name: submissions
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  approved_by_id  :integer
#  sign_id         :integer
#  submitted_by_id :integer
#
# Indexes
#
#  index_submissions_on_approved_by_id   (approved_by_id)
#  index_submissions_on_sign_id          (sign_id)
#  index_submissions_on_submitted_by_id  (submitted_by_id)
#
# Foreign Keys
#
#  approved_by_id   (approved_by_id => users.id)
#  sign_id          (sign_id => signs.id)
#  submitted_by_id  (submitted_by_id => users.id)
#
class Submission < ApplicationRecord
  validates :sign_id, :submitted_by_id, presence: true
  belongs_to :submitted_by, class_name: "User", foreign_key: "submitted_by_id"
  belongs_to :approved_by, class_name: "User", foreign_key: "approved_by_id", optional: true
  belongs_to :sign, class_name: "Sign", foreign_key: "sign_id"
end
