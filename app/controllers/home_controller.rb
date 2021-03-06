# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate!
  skip_before_action :authenticate!, only: [:index]

  def index
    puts 'HOME CONTROLLER'
    puts is_user_signed_in
    redirect_to new_user_session_path and return unless is_user_signed_in
    redirect_to promotions_path unless current_user.is_admin
  end

  def invitation
  end

  def invite
    email_invited = params[:email]
    role = params[:role]
    remittent = current_user.email
    UsersService.instance().send_invitation(email_invited,remittent,role)
    flash[:success] = 'Email succesfully sent!'
    redirect_to home_path
    logger.info("Email sent, from #{current_user.email}, to #{email_invited}")
  end
end
