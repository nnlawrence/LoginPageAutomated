module Hudl
  class Application
    def login_page
      @login_page ||= Hudl::LoginPage.new
    end
  end
end
