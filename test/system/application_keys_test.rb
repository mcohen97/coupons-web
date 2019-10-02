require "application_system_test_case"

class ApplicationKeysTest < ApplicationSystemTestCase
  setup do
    @application_key = application_keys(:one)
  end

  test "visiting the index" do
    visit application_keys_url
    assert_selector "h1", text: "Application Keys"
  end

  test "creating a Application key" do
    visit application_keys_url
    click_on "New Application Key"

    fill_in "Name", with: @application_key.name
    click_on "Create Application key"

    assert_text "Application key was successfully created"
    click_on "Back"
  end

  test "updating a Application key" do
    visit application_keys_url
    click_on "Edit", match: :first

    fill_in "Name", with: @application_key.name
    click_on "Update Application key"

    assert_text "Application key was successfully updated"
    click_on "Back"
  end

  test "destroying a Application key" do
    visit application_keys_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Application key was successfully destroyed"
  end
end
