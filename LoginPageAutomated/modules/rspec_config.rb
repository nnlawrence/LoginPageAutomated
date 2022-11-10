require 'capybara'
require 'capybara/rspec'
require './modules/capybara_sessions'
require './modules/capybara_config'
require 'rspec'
require 'rspec/retry'
require 'selenium-webdriver'

headless = ENV['HEADLESS'] ||= 'TRUE'
internal = ENV['INTERNAL'] ||= 'TRUE'
screen_width = ENV['SCREEN_WIDTH'] ||= '1600'
screen_height = ENV['SCREEN_HEIGHT'] ||= '1200'

RSpec.configure do |config| # rubocop:disable Metrics/BlockLength
  if headless.upcase == 'TRUE'
    config.before(:all) do
      Capybara.using_session(SecureRandom.uuid) do
        if headless.upcase == 'TRUE'
          args = ['--headless', '--disable-gpu', '--no-sandbox',
                  '--disable-dev-shm-usage', '--incognito', '--disable-notifications',
                  "--window-size=#{screen_width},#{screen_height}",
                  '--enable-features=NetworkService,NetworkServiceInProcess,
                  SameSiteByDefaultCookies,CookiesWithoutSameSiteMustBeSecure',
                  '--ignore-certificate-errors', 'ignore-ssl-errors']
          puts 'Running Headless'
          Capybara.register_driver :selenium_chrome_headless do |app|
            o = Selenium::WebDriver::Chrome::Options.new(args: args)
            Capybara::Selenium::Driver.new(app, browser: :chrome, options: o)
          end
          Capybara.default_driver = :selenium_chrome_headless
          Capybara.current_driver = Capybara.default_driver
        end
      end
    end
    config.before do
      Capybara.current_driver = Capybara.default_driver
    end
  else
    config.before do
      browser = ENV.fetch('BROWSER', :chrome).downcase.to_sym
      args = ['--disable-gpu', '--no-sandbox',
              '--disable-dev-shm-usage', '--incognito', '--disable-notifications',
              "--window-size=#{screen_width},#{screen_height}",
              '--enable-features=NetworkService,NetworkServiceInProcess,
                SameSiteByDefaultCookies,CookiesWithoutSameSiteMustBeSecure']
      Capybara.using_session(SecureRandom.uuid) do
        Capybara.register_driver :selenium_chrome do |app|
          o = Selenium::WebDriver::Chrome::Options
              .new(args: args)
          Capybara::Selenium::Driver.new(app, browser: browser, options: o)
        end
        Capybara.default_driver = :selenium_chrome
        Capybara.current_driver = Capybara.default_driver
      end
    end
  end

  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers
  config.formatter = :documentation
  config.verbose_retry = true
  config.display_try_failure_messages = true
  config.default_retry_count = 2
  config.default_sleep_interval = 2
  config.filter_run_excluding broken: true
  config.filter_run_excluding internal: true if internal.upcase == 'FALSE'
  ignore_app = { ENV.fetch('APP_ENV', 'qa').downcase.to_sym => false }
  config.filter_run_excluding ignore_app
  config.expect_with :rspec do |expectations|
    expectations.syntax = %i[should expect]
  end

  config.example_status_persistence_file_path = 'tmp/rspec/example_status_persistence_file_path.txt'

  config.after do |scenario|
    # do something
  end
end
