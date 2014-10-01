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
        process_address conn.body
      end

      private

      def process_address data
        if data == '[]'
          data
        else
          json = JSON.parse data
          address_json = json[0]["address"]
          name_n_street = "#{address_json["address_lines"].join("\n")}"
          <<-EOS.chomp.gsub('  ', '')
            #{name_n_street}
            #{address_json["town"]}
            #{address_json["county"]}
            #{address_json["postcode"]}
          EOS
        end
      end
    end
  end
end
