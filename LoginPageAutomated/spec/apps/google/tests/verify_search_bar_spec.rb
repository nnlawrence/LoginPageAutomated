feature 'Google', :google, prod: false do
  let(:google_app) { Google::Application.new }

  context 'when visiting home page' do
    scenario 'verify search bar is visible' do
      google_app.google_home_page.visit_home_page
      google_app.google_home_page.verify_search_bar_visible
    end
  end
end
