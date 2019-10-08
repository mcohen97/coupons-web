# frozen_string_literal: true

module ApplicationHelper
  def current_user
    if session[:user_id]
      @current_user ||= User.cached_find(session[:user_id])
    else
      @current_user = nil
    end
  end
  
  def current_user_organization
    org = Organization.cached_find (@current_user.organization_id)
    return org
  end

  def is_current_user_admin
    return @current_user.role == "administrator"
  end
end
