require 'webmock/rspec'
require_relative 'support/helper'
require 'courtfinder/client'

describe Courtfinder::Client::HousingPossession do
  before { WebMock.disable_net_connect! }

  describe '.get' do
    let(:client) { Courtfinder::Client::HousingPossession.new }
    let(:address) {
      "Cambridge County Court and Family Court Hearing Centre\n197 East Road\nCambridge\nCambridgeshire\nCB1 1BA"
    }

    def stub_with postcode
      stub_request(:get, "#{Courtfinder::SERVER}#{Courtfinder::Client::HousingPossession::PATH}#{postcode}")
        .to_return(:body => fixture('result.json'),
                   :headers => {:content_type => 'application/json; charset=utf-8'})
    end

    context 'when given postcode with no spaces' do
      postcode = 'sg80lt'

      it 'should return the court address' do
        stub_with postcode
        expect(client.get(postcode)).to eql address
      end
    end

    context 'when given postcode with spaces' do
      postcode = 'SG8 0LT'

      it 'should return the court address' do
        stub_with postcode
        expect(client.get(postcode)).to eql address
      end
    end

    context 'when invalid postcode is provided' do
      it 'should return an error' do
        stub_request(:get, "#{Courtfinder::SERVER}#{Courtfinder::Client::HousingPossession::PATH}fake")
          .to_return(:status => 200,
                     :body => '[]',
                     :headers => {})

        expect(client.get('fake')).to eql '[]'
      end
    end
  end
end
