# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  skip_before_action :verify_signed_out_user
  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    email = sign_in_params[:email];
    password = sign_in_params[:password];
    UsersService.instance().sign_in(email,password);
    @current_user = UsersService.instance().get_user(email);
    session[:user_id] = email;
    redirect_to home_path and return 
  rescue ServiceResponseError => error
    flash[:error] = "Wrong email or password"
    redirect_to user_session_path
  end

  # DELETE /resource/sign_out
  def destroy
    reset_session
    @current_user = nil;
    redirect_to new_user_session_path
    puts session
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
