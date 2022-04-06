# frozen-string-literal: true

# Defince the Users Controller
class UsersController < ApplicationController
  # show all users
  def index
    @users = User.all.order(created_at: :asc)
  end

  # show the selected user
  def show
    @user = User.find(params[:id])
  end

  # destroy (delete) the selected user
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: 'User was successfully deleted.'
  end
end
