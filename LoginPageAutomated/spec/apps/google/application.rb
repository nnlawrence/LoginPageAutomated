module Google
  class Application
    include Modules::Google::GoogleSharedMethods

    def google_home_page
      @google_home_page ||= GoogleHomePage.new
    end
  end
end
