class HomeController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  def invite
    UserMailer.with(user_invited: params[:email], sender: helpers.current_user).invitation_email.deliver_now
  end

end
