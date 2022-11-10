### Running HUDL Login Project

All hudl login tests are located in login_page_spec.rb --> spec/apps/hudl/tests/login_page_spec.rb

To run the test in sequence

Run $ `rspec spec/apps/hudl/tests/login_page_spec.rb`

Methods and selectors are located in login_page.rb --> spec/apps/hudl/tests/login_page.rb

Credentials are hidden. 

If credentials are needed for a successful test run,

Create file named "prod" under "dotenv.rb", then set EMAIL='youremail' and PASSWORD='yourpassword'. 

The login URL, 'https://www.hudl.com/login', is also set to a variable in login_page_spec.rb from "prod" file

## Running Tests
1. Run in sequence: `rspec spec/apps/[test dir/test name]`
2. Run in parallel: `parallel_rspec spec/apps/[test dir/test name]`
3. Run with rake: `rake run_tests` (you may also edit the rake file to run your own configured subset of test)
4. Run with env specified: `APP_ENV=prod rspec spec/apps/[test dir/test name]` (I have defaulted tests to run in prod for this project)

## Structure:
1. Object oriented programming
2. Model our Pages/Features in Classes
3. File path for our API helper methods will follow the path of the endpoint itself. Each part of the endpoint will be another folder with the final endpoint being a file that ends in `.rb`
4. Reusable Methods to handle repeated scenarios
5. Utilities file houses utility methods that can be globally useful in test suite

## Intro to Capybara
Capybara is a domain specific language – a DSL – that comes with methods that allow you to visit a page, fill in a textbox, click a button, click a link, check a checkbox, choose a radio button, selecting an item from a dropdown, search within a section of the page, test a login screen, and verify popups and modals work.