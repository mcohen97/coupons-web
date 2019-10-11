# frozen_string_literal: true

require_relative '../../lib/error/not_authorized_error.rb'

class ApplicationController < ActionController::Base
  rescue_from NotAuthorizedError, with: :not_authorized
  set_current_tenant_through_filter
  before_action :set_current_user, :set_organization

  def default_url_options
    if Rails.env.production?
      { host: ENV['HOSTS'] }
    else
      {}
    end
  end

  def set_organization
    if user_signed_in?
      current_organization = Organization.cached_find @current_user.organization_id
      set_current_tenant(current_organization)
    end
  end

  def authorize_user!
    if @current_user.role != 'administrator'
      raise NotAuthorizedError, 'Must be an administrator to access this functionality'
    end
  end

  private

  def set_current_user
    @current_user = current_user if user_signed_in?
  end

  def not_authorized
    respond_to do |format|
      logger.error('User not authorized to perform that ac.')
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :forbidden }
      format.json { render json: { error: 'Promotion not found.' }.to_json, status: :forbidden }
    end
  end
end
