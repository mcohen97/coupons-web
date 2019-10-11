# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authorize_user!, only: %i[invitation invite]

  def index
    redirect_to(new_user_session_path) && return unless user_signed_in?
    redirect_to promotions_path unless helpers.is_current_user_admin
  end

  def invitation
    redirect_to(new_user_session_path) && return unless user_signed_in?
  end

  def invite
    redirect_to(new_user_session_path) && return unless user_signed_in?
    invited_email = params[:email]
    invitation = EmailInvitation.create(user: current_user, invited_email: invited_email, organization_id: current_user.organization_id)
    UserMailer.with(email_invited: invited_email, sender: current_user, organization_name: current_user.organization, invitation: invitation).invitation_email.deliver_later
    flash[:success] = 'Email succesfully sent!'
    redirect_to home_path
    logger.info("Email sent, from #{current_user.email}, to #{invited_email}")
  end
end
