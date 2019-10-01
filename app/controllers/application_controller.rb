# frozen_string_literal: true

class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  before_action :set_current_user, :set_organization

  def set_organization
    if user_signed_in?
      current_organization = Organization.find @current_user.organization_id
      set_current_tenant(current_organization)
    end
  end

  # def user_signed_in?
  #  @current_user
  # end

  private

  def set_current_user
    @current_user = current_user if user_signed_in?
  end
end
