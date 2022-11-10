module Google
  class GoogleHomePage
    include Capybara::DSL
    def verify_search_bar_visible
      assert_selector('input[name="q"]')
    end

    def visit_home_page
      visit(ENV.fetch('GOOGLE_URL'))
    end
  end
end
