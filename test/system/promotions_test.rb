# frozen_string_literal: true

require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'logging in to the app' do
    visit root_path

    assert_selector 'h2', text: 'Log in'

    fill_in :user_email, with: 'mail1@domain1.com'
    fill_in :user_password, with: 'contrasen'
    click_on 'Log in'

    assert_redirected_to root_path

    assert_selector 'h1', text: 'Home'
  end

  test 'viewing promotions list' do
    perform_log_in

    visit promotions_path

    assert_selector 'h1', text: 'Home'
  end

  def perform_log_in
    visit root_path

    fill_in :user_email, with: 'mail1@domain1.com'
    fill_in :user_password, with: 'contrasen'
    click_on 'Log in'
 end
end
