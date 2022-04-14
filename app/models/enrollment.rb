# frozen-string-literal: true

class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :course

  # user can not be enrolled to the same course twice
  validates_uniqueness_of :user_id, scope: :course_id
  validates_uniqueness_of :course_id, scope: :user_id

  validate :cannot_be_enrolled_in_own_course

  def cannot_be_enrolled_in_own_course
    if user_id.present?
      if user_id == self.course.user_id
        errors.add(:user_id, 'cannot be enrolled in own course!')
      end
    end
  end


  def to_s
    id
  end
end
