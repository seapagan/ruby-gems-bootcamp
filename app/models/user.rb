# frozen-string-literal: true

# define the User class which will, surprisingly, hold all our registered users.
class User < ApplicationRecord
  has_many :enrollments, dependent: :restrict_with_error
  has_many :lessons, dependent: :restrict_with_error
  has_many :attendances, dependent: :restrict_with_error
  has_many :courses, dependent: :restrict_with_error

  # :timeoutable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable,
         :omniauthable, omniauth_providers: [:google_oauth2, :github, :twitter, :facebook]

  include Roleable

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(
        email: data['email'],
        password: Devise.friendly_token[0, 20]
      )
    end
    user.uid = access_token.uid
    user.provider = access_token.provider
    user.name = access_token.info.name unless user.name.present?
    user.image = access_token.info.image
    user.save

    user.confirmed_at = Time.now # autoconfirm user from omniauth
    user
  end

  after_create do
    # assign default role
    update(student: true)
  end

  after_touch do
    calculate_student_total
    calculate_teacher_total
  end

  monetize :student_total, as: :student_total_cents
  monetize :teacher_total, as: :teacher_total_cents

  def to_s
    email
  end

  def to_label
    email
  end

  private

  def calculate_student_total
    update_column :student_total, attendances.map(&:student_price_final).sum
  end

  def calculate_teacher_total
    update_column :teacher_total, lessons.map(&:teacher_price_final).sum
  end
end
