require 'webmock/rspec'
require_relative 'support/helper'
require 'courtfinder/client'

describe Courtfinder::Client::HousingPossession do
  before { WebMock.disable_net_connect! }
  let(:json) { fixture('result.json') }
  let(:client) { Courtfinder::Client::HousingPossession.new }

  def stub_with postcode
    stub_request(:get, "#{Courtfinder::SERVER}#{Courtfinder::Client::HousingPossession::PATH}#{postcode}")
      .to_return(:body => json,
                 :headers => {:content_type => 'application/json; charset=utf-8'})
  end

  describe '.get' do

    before { stub_with postcode }

    context 'when given postcode with no spaces' do
      let(:postcode) { 'sg80lt' }

      it 'should return the court address' do
        expect(client.get(postcode)).to eql json
      end
    end

    context 'when given postcode with spaces' do
      let(:postcode) { 'SG8 0LT' }

      it 'should return the court address' do
        expect(client.get(postcode)).to eql json
      end
    end

    context 'when invalid postcode is provided' do
      let(:json) { '[]' }
      before do
        stub_request(:get, "#{Courtfinder::SERVER}#{Courtfinder::Client::HousingPossession::PATH}fake")
          .to_return(:status => 200,
                     :body => '[]',
                     :headers => {})
      end

      it 'should return an error' do
        expect(client.get('fake')).to eql json
      end
    end
  end
end
