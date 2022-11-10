module Hudl
  class LoginPage
    include Capybara::DSL
    include ::RSpec::Matchers
    include Capybara::RSpecMatchers

    def enter_email(email)
      fill_in('Email', with: email)
    end

    def enter_password(password)
      fill_in('Password', with: password)
    end

    def click_login_button
      click_button('Log In')
    end

    def verify_home_content_is_viewable
      expect(page).to have_css('#home-content')
    end

    def verify_back_button_arrow_is_visible
      expect(page).to have_selector('.styles_backIcon_1nBYGKhbTIbTmIULDJg1MZ')
    end

    def click_signup_link_and_verify_url
      find('a', text: 'Sign up').click
      expect(page).to have_current_path('https://www.hudl.com/register/signup')
    end

    def verify_email_input_field_visible
      expect(page).to have_field('Email')
    end

    def verify_password_input_field_visible
      expect(page).to have_field('Password')
    end

    def verify_login_button_visible
      expect(page).to have_button('Log In')
    end

    def verify_remember_checkbox_visible_and_functioning
      find('.uni-form__check-indicator__background').click
      expect(page).to have_selector('.uni-form__check-item--is-checked')
    end

    def verify_need_help_link_visible_and_functioning
      find('a', text: 'Need help?').click
      expect(page).to have_current_path('https://www.hudl.com/login/help#')
    end

    def verify_organization_login_button_functioning
      find('button', text: 'Log In with an Organization').click
      expect(page).to have_current_path('https://www.hudl.com/app/auth/login/organization')
    end

    def verify_invalid_credentials_login_fails_with_error_message
      error_message = "We didn't recognize that email and/or password."
      fill_in('Email', with: 'fakeemail@hudltest.com')
      fill_in('Password', with: 'password1234')
      click_button('Log In')
      expect(page).to have_content(error_message)
    end
  end
end
