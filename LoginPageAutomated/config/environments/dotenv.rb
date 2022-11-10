require 'dotenv'

# Setup build specific environment variables
ENV['APP_ENV'] = ENV.fetch('APP_ENV', 'PROD').upcase

# Load environment variables
Dotenv.load("./config/environments/#{ENV['APP_ENV'].downcase}.local",
            './config/environments/global.local',
            "./config/environments/#{ENV['APP_ENV'].downcase}",
            './config/environments/global')
