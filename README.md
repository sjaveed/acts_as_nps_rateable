# acts_as_nps_rateable

acts_as_nps_rateable provides Net Promoter Score (NPS) ratings and analysis for your ActiveRecord-based models.  Net
Promoter Score is a measurement of customer satisfaction; it is the ratio of the percentage of customers who would
recommend your product/service to the percentage of customers who would not recommend it.

NPS is documented in more detail at Wikipedia: http://en.wikipedia.org/wiki/Net_Promoter

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_nps_rateable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_nps_rateable

## Usage

Add the following line to the model you wish to store NPS ratings for:

    acts_as_nps_rateable

e.g.

    class Post < ActiveRecord::Base
      acts_as_nps_rateable
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
