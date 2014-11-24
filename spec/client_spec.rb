require 'courtfinder/client'

describe Courtfinder::Client::HousingPossession do
  let(:result) do
    [{ "name" => "Cambridge County Court and Family Court",
       "address" =>
       { "town" => "Cambridge",
         "address_lines" =>
         ["Cambridge County Court and Family Court Hearing Centre",
          "197 East Road"],
         "type" => "Postal",
         "postcode" => "CB1 1BA",
         "county" => "Cambridgeshire"
       }
     }]
  end

  let(:client) { Courtfinder::Client::HousingPossession.new }

  def full_url postcode
    "#{Courtfinder::SERVER}#{Courtfinder::Client::HousingPossession::PATH}#{postcode}"
  end

  describe '.get' do
    context 'with valid postcode' do
      context 'when given postcode with no spaces' do
        let(:postcode) { 'sg80lt' }

        it 'should return the court address', :vcr do
          expect(client.get(postcode)).to match result
        end
      end

      context 'when given postcode with spaces' do
        let(:postcode) { 'SG8 0LT' }

        it 'should return the court address', :vcr do
          expect(client.get(postcode)).to eql result
        end
      end
    end

    context 'with invalid postcode' do
      let(:postcode) { 'fake' }

      it 'should return empty array', :vcr do
        expect(client.get(postcode)).to match({ :error => "postcode couldn't be found" })
      end
    end

    context 'when a timeout happens' do
      let(:postcode) { 'SW1H9AJ' }

      it 'should return an error', :vcr do
        expect(client.get(postcode)).to match({ :error => 'timeout' })
      end
    end
  end
end
