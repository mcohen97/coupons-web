# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate!

  def index
    puts is_user_signed_in
    redirect_to promotions_path unless is_current_user_admin
  end

  def invitation
  end

  def invite
    invited_email = params[:email]
    invitation = EmailInvitation.create(user: current_user, invited_email: invited_email, organization_id: current_user.organization_id)
    UserMailer.with(email_invited: invited_email, sender: current_user, organization_name: current_user.organization, invitation: invitation).invitation_email.deliver_later
    flash[:success] = 'Email succesfully sent!'
    redirect_to home_path
    logger.info("Email sent, from #{current_user.email}, to #{invited_email}")
  end
end
