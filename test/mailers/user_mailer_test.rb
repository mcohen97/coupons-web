# frozen_string_literal: true

require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "invite" do
    # Create the email and store it for further assertions
    email = UserMailer
    .with(email_invited: 'friend@example.com', sender: users(:one), organization_name: 1, invitation: email_invitations(:one))
    .invitation_email
 
    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_later
    end
 
    # Test the body of the sent email contains what we expect it to
    assert_equal ['from@example.com'], email.from
    assert_equal ['friend@example.com'], email.to
    assert_equal 'name1 invited you to join Coupons', email.subject
  end
end
