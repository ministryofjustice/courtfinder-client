require 'webmock/rspec'
require_relative './support/helper'
require 'courtfinder/client'

describe Courtfinder::Client::HousingPossession do
  before { WebMock.disable_net_connect! }

  describe '.get' do
    postcode = 'sg80lt'
    let(:client) { Courtfinder::Client::HousingPossession.new }
    let(:address) do
      "Cambridge County Court and Family Court Hearing Centre
197 East Road
Cambridge\nCambridgeshire\nCB1 1BA"
    end

    it 'should return the court address' do
      stub_request(:get, "#{Courtfinder::SERVER}#{Courtfinder::Client::HousingPossession::PATH}#{postcode}")
        .to_return(:body => fixture('result.json'),
                   :headers => {:content_type => 'application/json; charset=utf-8'})

      expect(client.get(postcode)).to eql address
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
