require 'capybara'

Capybara.configure do |config|
  config.run_server = true
  config.default_max_wait_time = 15
  config.match = :prefer_exact
  config.ignore_hidden_elements = true
  config.visible_text_only = true
  config.automatic_reload = true
  config.default_driver = :selenium
end
