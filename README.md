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

Once you've installed the gem, you'll need to install the migrations required by acts_as_nps_rateable into your project
and run all pending migrations:

    rails generate acts_as_nps_rateable:install
    rake db:migrate

Now you're ready to use acts_as_nps_rateable.

## Usage

### Setting up the Models

acts_as_nps_rateable relies on the concept of rateables and raters.

A rateable is any model which can be given a rating from 0 to 10 (inclusive) and an optional review.  An example of a
rateable might be a Restaurant model.  Set up a rateable by adding the following line to the model you wish to be a
rateable:

    acts_as_nps_rateable

e.g.

    class Restaurant < ActiveRecord::Base
      acts_as_nps_rateable
    end

A rater is any model which can give a rateable that rating and is essentially the user to attribute that rating to.  An
example of a rater will usually be a User model it's possible to have multiple raters in your system e.g. an Employee
and a Manager, both of which can rate any rateable.  Set up a rater by adding the following line to the model you wish
to be a rater:

    acts_as_nps_rater

e.g.

    class User < ActiveRecord::Base
      acts_as_nps_rater
    end

### Rating

Let's assume we have the User and Restaurant models in the system with specific instances of each in our code as follows:

    snob = User.find(31337)
    rateotu = Restaurant.find(42)

Our rater has the following methods available to her:

    snob.rate(rateotu, 5)               # Rates the restaurant a 5 on a scale from 0 to 10 inclusive
    snob.rate(rateotu, 3)               # Overwrites the restaurant's rating to a 3
    snob.average_rating                 # Returns the average score of all the ratings snob has given
    snob.rated?(rateotu)                # Returns true if snob has rated this restaurant before.  False otherwise.
    snob.rating_for(rateotu)            # Returns the score snob gave this restaurant before.  This could be nil.

    snob.review("It was OK", rateotu)   # Adds a review to an existing rating by snob for this restaurant.

Our rateable has the following methods available:

    rateotu.rate(9, snob)               # Adds a rating for the restaurant by a given rater
    rateotu.rate(10, snob)              # Overwrites the rating given by snob with a better number
    rateotu.average_rating              # Returns the average score of all the ratings this restaurant has received
    rateotu.rated_by?(snob)             # Returns true if snob has rated this restaurant before.  False otherwise.
    rateotu.rating_by(snob)             # Returns the score snob gave this restaurant before.  This could be nil.

    # We will use this recent_ratings variable in some examples below.  It's meant to be all ratings that were recorded
    # in the last month.
    recent_ratings = rateotu.nps_ratings.where("created_at > ?", 1.month.ago)

    rateotu.promoters                   # Returns a count of the number of all ratings considered promoters in the NPS sense
    rateotu.promoters(recent_ratings)   # Returns a count of the number of recent ratings considered promoters
    rateotu.passives                    # Returns a count of the number of all ratings considered passives in the NPS sense
    rateotu.passives(recent_ratings)    # Returns a count of the number of recent ratings considered passives
    rateotu.detractors                  # Returns a count of the number of all ratings considered detractors in the NPS sense
    rateotu.detractors(recent_ratings)  # Returns a count of the number of recent ratings considered detractors
    
    rateotu.net_promoter_score          # Returns the Net Promoter Score based on all ratings for this restaurant
    rateotu.net_promoter_score(recent_ratings)  # Returns the Net Promoter Score based on recent ratings only
    
    rateotu.review("It was Great!", snob)   # Adds a review to an existing rating by snob for this restaurant

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
