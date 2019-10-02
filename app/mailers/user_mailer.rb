class UserMailer < ApplicationMailer
    def invitation_email
        @email_invited = params[:email_invited]
        @sender = params[:sender]
        @invitation = params[:invitation]
        @organization_name = params[:organization_name]
        mail(to: @email_invited, subject: @sender.name + ' invited you to join Coupons')
    end
end
