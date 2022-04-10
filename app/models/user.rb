# frozen-string-literal: true

# define the User class which will, surprisingly, hold all our registered users.
class User < ApplicationRecord
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

  def to_s
    email
  end
end
