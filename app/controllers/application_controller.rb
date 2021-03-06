# frozen_string_literal: true

require_relative '../../lib/error/not_authorized_error.rb'

class ApplicationController < ActionController::Base
  rescue_from StandardError, with: :server_error
  rescue_from UnauthorizedError, with: :not_authorized
  rescue_from ExpiredTokenError, with: :ask_sign_in

  before_action :set_current_user, :set_current_organization, :set_token, except: [:not_authorized, :not_found, :server_error]

  helper_method :is_user_signed_in
  helper_method :is_current_user_admin
  helper_method :current_organization
  helper_method :current_user

  def default_url_options
    if Rails.env.production?
      { host: ENV['HOSTS'] }
    else
      {}
    end
  end

  def authorize_user!
      raise NotAuthorizedError, 'Must be an administrator to access this functionality' unless @current_user.is_admin
  end

  def current_user
    if session[:user_id] and session[:user_data]
      @current_user = UserDto.new(session[:user_data])
      session[:org_id] = @current_user.org_id
    elsif session[:user_id]
      result = UsersService.instance().get_user(session[:user_id])
      if result.success
        session[:user_data] = result.data
        @current_user = UserDto.new(result.data)
        session[:org_id] = @current_user.org_id
        return @current_user
      else
        reset_session
        redirect_to new_user_session_path and return
      end
    else
      return nil
    end
    return @current_user
  end

  def current_organization
    if session[:org_id] and session[:org_data]
      @current_organization = OrganizationDto.new(session[:org_data])
    elsif session[:org_id]
      result = UsersService.instance().get_organization(session[:org_id])
      session[:org_data] = result.data
      @current_organization = OrganizationDto.new(result.data)
      return @current_organization
    else
      return nil
    end
    return @current_organization
  end

  def is_user_signed_in
    return not(session[:token].nil?)
  end

  def authenticate!
    if not is_user_signed_in
      flash[:error] = 'You must sign in or sign up first'
      redirect_to new_user_session_path and return
    end
  end 


  private

  def not_authorized
    respond_to do |format|
      logger.error('User not authorized to perform that ac.')
      format.html { render file: "#{Rails.root}/public/401", layout: false, status: :forbidden }
    end
  end

  def not_found
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :forbidden }
    end
  end

  def server_error
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/500", layout: false, status: :forbidden }
    end
  end

  def ask_sign_in
    reset_session
    @current_user = nil;
    flash[:error] = "Session expired. Please, sign in again."
    redirect_to new_user_session_path
  end

  def set_current_user
    @current_user = current_user
  end

  def set_current_organization
    @current_organization = current_organization
  end

  def set_token
    HttpRequests.set_token(token)
  end

  def token
    session[:token]
  end



end
