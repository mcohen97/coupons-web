# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def invite
    invited_email = params[:email]
    invitation = EmailInvitation.create(user: current_user, invited_email: invited_email, organization_id: current_user.organization_id)
    puts invitation.invitation_code
    UserMailer.with(email_invited: invited_email, sender: current_user, organization_name: current_user.organization, invitation: invitation).invitation_email.deliver_now
  end
end
