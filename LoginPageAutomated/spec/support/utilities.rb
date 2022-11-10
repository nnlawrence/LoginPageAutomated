module AutomationFramework
  # This class is for utility methods that can be used by all tests
  class Utilities
    require 'net/sftp'
    include Capybara::DSL
    include Capybara::RSpecMatchers
    include ::RSpec::Matchers
    include Net::SFTP

    def click_ok_msgbox
      page.accept_confirm
    end

    def verify_response_time(acceptable_time = 0)
      start_time = Time.now
      puts 'starting a timely process. . .'.green
      yield
      response_time = Time.now - start_time
      puts "seconds to complete process: #{response_time}".green
      expect(response_time).to be <= acceptable_time unless acceptable_time == 0
    end

    def force_timeout(maximum_seconds = 0, message: true)
      puts '    starting a timely process. . .'.green if message
      begin
        Timeout.timeout(maximum_seconds) do
          loop until yield
        end
      rescue Timeout::Error
        raise "Reached the maximum allotted time of #{maximum_seconds} seconds for the process"
      end
    end

    def self.check_member_is_created_and_challenged(user_guid, member_guid)
      10.times do
        response = Platform::Users::UserGUID::Members::MemberGUID.get(user_guid, member_guid)
        break if JSON.parse(response.body)['member']['connection_status'] == 'CHALLENGED'

        sleep(3)
      end
    end

    def self.create_account_hash(hash)
      {
        account: hash
      }
    end

    def self.create_challenges_hash(challenges_array)
      {
        member: {
          challenges: challenges_array
        }
      }
    end

    def self.create_member_hash(institution_code, credentials_array)
      {
        member: {
          institution_code: institution_code,
          credentials: credentials_array
        }
      }
    end

    def self.create_scheduled_payment_hash(hash)
      {
        scheduled_payment: hash
      }
    end

    def self.create_tag_hash(hash)
      {
        tag: hash
      }
    end

    def self.create_transaction_hash(hash)
      {
        transaction: hash
      }
    end

    def self.create_updated_member_hash(hash)
      {
        member: hash
      }
    end

    def self.create_user_hash(hash)
      {
        user: hash
      }
    end

    def self.delete_member_if_exists(user_guid)
      response = Platform::Users::UserGUID::Members.get(user_guid)
      case JSON.parse(response.body)['members'].empty?
      when false
        member_guid = JSON.parse(response.body)['members'][0]['guid']
        Platform::Users::UserGUID::Members::MemberGUID.delete(user_guid, member_guid)

        sleep(2)
      end
    end

    def self.delete_tag_with_same_name_if_exists(user_guid, tag_name)
      response = Platform::Users::UserGUID::Tags.get(user_guid)
      tags_hash = JSON.parse(response.body)['tags']
      case tags_hash.empty?
      when false
        tags_hash.each do |element|
          Platform::Users::UserGUID::Tags::TagGUID.delete(user_guid, element['guid']) if element['name'] == tag_name
        end
      end
    end

    def self.get_member_and_response(member_data)
      member_data.each do |member|
        response = Platform::Users::UserGUID::Members::MemberGUID::CheckBalance.post(member[:user_guid], member[:member_guid])
        return response, member if response.code == '202'
      end
    end

    def self.get_user_and_response(user_data)
      user_data.each do |user|
        bearer_token = Platform::PaymentProcessorAuthorizationCode.post(user[:user_guid], user[:member_guid], user[:account_guid])
        response = Platform::Account::CheckBalance.post(bearer_token)
        return response, user if response.code == '202'
      end
    end

    def self.retrieve_data(csv_file)
      data = CSV.read(csv_file)
      descriptor = data.shift
      descriptor = descriptor.map(&:to_sym)
      data.map { |test_data| descriptor.zip(test_data).to_h }
    end
  end
end
