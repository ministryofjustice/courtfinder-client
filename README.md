# Courtfinder::Client

Client for UK Government [Court and tribunal finder](https://courttribunalfinder.service.gov.uk/) API

Currently **only** implemented querying courts for **'Housing possesion'**

## Installation

Add this line to your application's Gemfile:

    gem 'courtfinder-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install courtfinder-client

## Usage

Sample usage:

    require 'courtfinder/client'

    client = Courtfinder::Client::HousingPossession.new
    client.get 'SG8 0LT'

Which will return the address of the court in 'Housing possession'
area of law for the given postcode.

**TODO:** Add support for courts in other areas of law.

## Contributing

1. Fork it ( https://github.com/ministryofjustice/courtfinder-client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
