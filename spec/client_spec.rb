require 'webmock/rspec'
require_relative 'support/helper'
require 'courtfinder/client'

describe Courtfinder::Client::HousingPossession do
  before { WebMock.disable_net_connect! }

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

  def stub_with postcode
    stub_request(:get, full_url(postcode))
      .to_return(:body => fixture('result.json'),
                 :headers => {:content_type => 'application/json; charset=utf-8'})
  end

  def blank_result postcode
    stub_request(:get, full_url(postcode))
      .to_return(:status => 200,
                 :body => '[]',
                 :headers => {})
  end

  def error_result postcode
    stub_request(:get, full_url(postcode))
      .to_return(:status => 404,
                 :body => '',
                 :headers => {})
  end

  describe '.get' do
    context 'with valid postcode' do
      before { stub_with postcode }

      context 'when given postcode with no spaces' do
        let(:postcode) { 'sg80lt' }

        it 'should return the court address' do
          expect(client.get(postcode)).to eql result
        end
      end

      context 'when given postcode with spaces' do
        let(:postcode) { 'SG8 0LT' }

        it 'should return the court address' do
          expect(client.get(postcode)).to eql result
        end
      end
    end

    context 'when invalid postcode is provided' do
      it 'should return a blank array' do
        postcode = 'fake'
        blank_result postcode
        expect(client.get(postcode)).to eql []
      end

      it 'should not raise an error' do
        postcode = 'break'
        error_result postcode
        expect { client.get(postcode) }.not_to raise_error
      end
    end
  end

  describe '.empty?' do
    context 'when there are results returned' do
      let(:postcode) { 'SG8 0LT' }

      before do
        stub_with postcode
        client.get postcode
      end

      it 'should be false' do
        expect(client.empty?).to be false
      end
    end

    context 'when there are no results returned' do
      let(:postcode) { 'fake' }

      before do
        blank_result postcode
        client.get postcode
      end

      it 'should be true' do
        expect(client.empty?).to be true
      end
    end
  end
end
