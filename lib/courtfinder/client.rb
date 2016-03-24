require 'courtfinder/client/version'
require 'excon'
require 'json'
require 'uri'

module Courtfinder
  SERVER = 'https://courttribunalfinder.service.gov.uk'
  module Client
    class HousingPossession
      PATH='/search/results.json?aol=housing-possession&postcode='
      def get postcode
        conn = nil
        begin
          endpoint = "#{Courtfinder::SERVER}#{PATH}#{URI.escape(postcode)}"
          conn = Excon.get(endpoint, :read_timeout => 90)
          check_for_error_code conn
        rescue Excon::Errors::RequestTimeout
          @json = { error: 'timeout' }
        end

        @json
      end

      def empty?
        @json.empty?
      end

      private

      def check_for_error_code response
        process response.body if response.status == 200
        @json = { error: 'timeout' } if response.status == 400
        @json = { error: "postcode couldn't be found" } if response.status == 500
      end

      def process data
        begin
          parsed = JSON.parse data
          @json = (parsed.size > 1) ? [parsed[0]] : parsed
          cleanup_court_data
        rescue JSON::ParserError
          @json = { error: 'invalid JSON returned' }
        end
      end

      def cleanup_court_data
        unwanted_attributes = ['areas_of_law', 'slug', 'dx_number',
                               'lon', 'lat', 'types', 'number', 'distance']
        @json.each do |court|
          unwanted_attributes.each {|attr| court.delete attr }
        end
      end
    end
  end
end
