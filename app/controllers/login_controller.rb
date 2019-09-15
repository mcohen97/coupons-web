# frozen_string_literal: true

class LoginController < ApplicationController
  def index
    # user = User.find_by(email: params[:email])
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = 'Successfully Logged In'
      redirect_to '/users'
    else
      flash[:warning] = "Invalid Username or Password"
      redirect_to '/login'
    end
  end
end
