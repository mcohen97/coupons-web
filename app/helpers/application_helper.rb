module ApplicationHelper
    def current_user
        if session[:user_id]
          @current_user ||= User.find(session[:user_id])
        else
          @current_user = nil
        end
    end

    def current_user_organization
      org = Organization.find_by @current_user.organization
      return org
    end

    def is_current_user_admin
      return @current_user.role == "administrator"
    end
end
