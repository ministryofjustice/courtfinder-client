require 'courtfinder/client/version'
require 'faraday'
require 'json'
require 'uri'

module Courtfinder
  SERVER = 'https://courttribunalfinder.service.gov.uk/'
  module Client
    class HousingPossession
      PATH='/search/results.json?area_of_law=Housing+possession&postcode='

      def get postcode
        conn = nil
        begin
          endpoint = "#{Courtfinder::SERVER}#{PATH}#{URI.escape(postcode)}"
          Timeout::timeout(1.5) { conn = Faraday.get endpoint }
          process conn.body
        rescue Faraday::TimeoutError
          []
        end
      end

      def empty?
        @json.empty?
      end

      private

      def process data
        begin
          @json = JSON.parse data
          unwanted_attributes = ['areas_of_law', 'slug', 'dx_number',
                               'lon', 'lat', 'types', 'number']
          @json.each do |court|
            unwanted_attributes.each {|attr| court.delete attr }
          end
        rescue JSON::ParserError
          @json = []
        end
      end
    end
  end
end
