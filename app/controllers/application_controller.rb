# frozen_string_literal: true

require_relative '../../lib/error/not_authorized_error.rb'

class ApplicationController < ActionController::Base
  rescue_from NotAuthorizedError, with: :not_authorized
  before_action :set_current_user, :set_current_organization

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
      user_data = UsersService.instance().get_user(session[:user_id])
      session[:user_data] = user_data
      @current_user = UserDto.new(user_data)
      session[:org_id] = @current_user.org_id
      return @current_user
    else
      return nil
    end
    return @current_user
  end

  def current_organization
    if session[:org_id] and session[:org_data]
      @current_organization = OrganizationDto.new(session[:org_data])
    elsif session[:org_id]
      org_data = UsersService.instance().get_organization(session[:org_id])
      session[:org_data] = org_data
      @current_organization = OrganizationDto.new(org_data)
      return @current_organization
    else
      return nil
    end
    return @current_organization
  end

  def is_user_signed_in
    return not(session[:user_id].nil?)
  end

  def authenticate!
    redirect_to new_user_session_path unless is_user_signed_in
  end

  private

  def set_current_user
    @current_user = current_user
  end

  def set_current_organization
    @current_organization = current_organization
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
  helper_method :current_organization
  helper_method :current_user
end
