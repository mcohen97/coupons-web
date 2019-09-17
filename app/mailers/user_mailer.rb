class UserMailer < ApplicationMailer
    def invitation_email
        @user_invited = params[:user_invited]
        @sender = params[:sender]
        mail(to: @user_invited, subject: @sender.name + ' invited you to join Coupons')
    end
end
