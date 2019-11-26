# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  helper_method :is_invitation_sign_up

  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
    if is_invitation_sign_up
      invitation_code = params['invitation_code']
    end
  end

  # POST /resource
  def create
    UsersService.instance().create_user(@newUserDto)
    UsersService.instance().sign_in(@newUserDto.email, @newUserDto.password)
    redirect_to home_path and return 
  end

  # GET /resource/edit
  def edit
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    if not is_invitation_sign_up
      puts 'entra en not is invitation'
      role = {'name'=>'ADMIN','permissions'=>[]}
    else
      puts 'entra en invitation'
      role = {'name'=>'','permissions'=>[]}
    end
    args = {
      'username'=>params[:user][:email],
      'password'=>params[:user][:password],
      'name'=>params[:user][:name],
      'surname'=>params[:user][:surname],
      'org_id'=>params[:user][:organization],
      'role'=>role,
      'invitation_id'=>params[:invitation_code]
    }

    @newUserDto = UserDto.new(args)
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name surname role organization organization_id avatar invitation_code])
  end

  def is_invitation_sign_up
    params.key?('invitation_code') || params.key?(:invitation_code)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

end
