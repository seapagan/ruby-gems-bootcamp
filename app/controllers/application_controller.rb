# frozen-string-literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
end
