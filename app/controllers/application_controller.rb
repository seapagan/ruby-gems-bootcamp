# frozen-string-literal: true

# define the main ApplicationController class
class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    user_path(resource)
  end
end
