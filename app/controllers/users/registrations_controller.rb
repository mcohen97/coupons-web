# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    if is_invitation_sign_up
      invitation_code = params["invitation_code"]
      if not is_valid_invitation_code(invitation_code)
        redirect_to new_user_registration_url, :flash => { :error => "The invitation is invalid. Please, contact your organization administrator and ask for a new invitation." }  and return   
      end    
    end
    super
  end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  def edit
    super
    @gfre = "fe"
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
    params[:user][:role] = "administrator"
    if is_invitation_sign_up
        invitation_code = params[:invitation_code]
        if is_valid_invitation_code(invitation_code)
          invitation = EmailInvitation.find_by invitation_code: invitation_code
          params[:user][:organization] = Organization.find(invitation.organization_id).organization_name
          params[:user][:role] = "organization_user"
          params[:user][:invitation_code] = invitation_code
        end
    end

    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :surname, :role, :organization, :avatar, :invitation_code])
  end

  def is_invitation_sign_up
    params.has_key?("invitation_code") || (params.has_key?(:invitation_code))
  end

  def is_valid_invitation_code(invitation_code)
    invitation_exists = EmailInvitation.exists?(invitation_code: invitation_code)
    if invitation_exists
      invitation = EmailInvitation.find_by invitation_code: invitation_code
    end
    invitation_exists && !invitation.already_used
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
