require 'courtfinder/client/version'
require 'faraday'
require 'json'
require 'uri'

module Courtfinder
  SERVER = 'http://54.72.152.89'
  module Client
    class HousingPossession
      PATH='/search/results.json?area_of_law=Housing+possession&postcode='

      def get postcode
        conn = Faraday.get "#{Courtfinder::SERVER}#{PATH}#{URI.escape(postcode)}"
        process conn.body
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
