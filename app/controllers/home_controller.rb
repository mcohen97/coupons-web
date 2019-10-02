class HomeController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  def invitation

  end

  def invite
    invited_email = params[:email]
    invitation = EmailInvitation.create(user: current_user, invited_email: invited_email, organization_id: current_user.organization_id) 
    UserMailer.with(email_invited: invited_email, sender: current_user, organization_name: current_user.organization, invitation: invitation).invitation_email.deliver_now
    flash[:success] = "Email succesfully sent!"
    redirect_to home_path
  end

end

