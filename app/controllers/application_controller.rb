# frozen_string_literal: true

require_relative '../../lib/error/not_authorized_error.rb'

class ApplicationController < ActionController::Base
  #rescue_from NotAuthorizedError, with: :not_authorized
 #before_action :set_current_user#, :set_organization

  def default_url_options
    if Rails.env.production?
      { host: ENV['HOSTS'] }
    else
      {}
    end
  end

  def set_organization
    if is_user_signed_in
      current_organization = UsersService.instance().get_organization(@current_user['org_id'])
    end
  end

  def authorize_user!
    if @current_user.role != 'administrator'
      raise NotAuthorizedError, 'Must be an administrator to access this functionality'
    end
  end

  def current_user
    if is_user_signed_in
      @current_user ||= UsersService.instance().get_user(session[:user_id])
    else
      @current_user = nil
    end
    return @current_user
  end

  def current_user_organization
    if is_user_signed_in
      @current_organization = UsersService.instance().get_organization(current_user['org_id'])
    else
      @current_organization = nil
    end
    return @current_organization
  end

  def is_current_user_admin
    puts @current_user
    return true
  end

  def is_user_signed_in
    return not(session[:user_id].nil?)
  end

  def authenticate!
    
    if not is_user_signed_in
      redirect_to new_user_session_path
    end
  end

  private

  def set_current_user
    @current_user = current_user
  end

  def not_authorized
    respond_to do |format|
      logger.error('User not authorized to perform that ac.')
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :forbidden }
      format.json { render json: { error: 'Promotion not found.' }.to_json, status: :forbidden }
    end
  end

  helper_method :is_user_signed_in
  helper_method :is_current_user_admin
  helper_method :current_user_organization
  helper_method :current_user
end
