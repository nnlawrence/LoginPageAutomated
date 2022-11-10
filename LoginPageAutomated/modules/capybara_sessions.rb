module Capybara
  module Driver
    module Sessions
      def self.session(id, sessions)
        Capybara.instance_variable_set('@session_pool', {
                                         "#{Capybara.current_driver}#{Capybara.app.object_id}" => sessions[id]
                                       })
      end

      def self.using_session(id)
        sessions ||= {}
        sessions[:default] ||= Capybara.current_session
        sessions[id]       ||= Capybara::Session.new(Capybara.current_driver, Capybara.app)
        session(id, sessions)

        yield

        session(:default, sessions)
      end
    end
  end
end
