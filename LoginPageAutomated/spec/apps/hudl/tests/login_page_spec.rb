require 'spec_helper'

feature 'Hudl Log In Page:' do
  let(:hudl) { Hudl::Application.new }
  let(:email) { ENV.fetch('EMAIL') }
  let(:password) { ENV.fetch('PASSWORD') }
  let(:hudl_login_url) { ENV.fetch('HUDL_LOGIN_URL') }

  before do
    visit hudl_login_url
  end

  context 'when visiting login page' do
    scenario 'Verify User Can Log In And View Content' do
      hudl.login_page.enter_email(email)
      hudl.login_page.enter_password(password)
      hudl.login_page.click_login_button
      hudl.login_page.verify_home_content_is_viewable
    end

    scenario 'Verify Displayed Icon: Back Button Arrow Is Visible' do
      hudl.login_page.verify_back_button_arrow_is_visible
    end

    scenario 'Verify Displayed Link: Sign Up Is Visible And Contains Expected Path' do
      hudl.login_page.click_signup_link_and_verify_url
    end

    scenario 'Verify Displayed Input: Email Is Visible' do
      hudl.login_page.verify_email_input_field_visible
    end

    scenario 'Verify Displayed Input: Password Is Visible' do
      hudl.login_page.verify_password_input_field_visible
    end

    scenario 'Verify Displayed Button: Log In Is Visible' do
      hudl.login_page.verify_login_button_visible
    end

    scenario 'Verify Displayed Checkbox: Remember me Is Visible And Functioning' do
      hudl.login_page.verify_remember_checkbox_visible_and_functioning
    end

    scenario 'Verify Displayed Link: Need help? Is Visible And Functioning' do
      hudl.login_page.verify_need_help_link_visible_and_functioning
    end

    scenario 'Verify Displayed Button: Log In with an Organization Is Visble And Functioning' do
      hudl.login_page.verify_organization_login_button_functioning
    end
  end

  context 'when logging in with invalid credentials on login page' do
    scenario 'Verify User Unable To Login And Error Message Displays' do
      hudl.login_page.verify_invalid_credentials_login_fails_with_error_message
    end
  end
end
