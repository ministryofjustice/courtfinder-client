require 'webmock'
require 'webmock/rspec'
require 'vcr'
require_relative 'support/helper'
require 'courtfinder/client'


RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  VCR.configure do |config|
    config.default_cassette_options = { :record => :new_episodes }
    config.configure_rspec_metadata!
    config.cassette_library_dir = 'spec/vcr'
    config.allow_http_connections_when_no_cassette = true
    config.hook_into :excon
    config.before_http_request do |request|
      if request.uri == "#{Courtfinder::SERVER}#{Courtfinder::Client::HousingPossession::PATH}SW1H9AJ"
        raise Excon::Errors::RequestTimeout.new('Boom')
      end
    end
  end
end
