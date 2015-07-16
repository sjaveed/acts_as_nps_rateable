require File.join(File.dirname(__FILE__), "acts_as_nps_rateable/railtie")

module ActsAsNpsRateable
  autoload :Hook, File.join(File.dirname(__FILE__), "acts_as_nps_rateable/hook")
  autoload :RateableInstanceMethods, File.join(File.dirname(__FILE__), "acts_as_nps_rateable/rateable_instance_methods")
  autoload :RaterInstanceMethods, File.join(File.dirname(__FILE__), "acts_as_nps_rateable/rater_instance_methods")
end

require 'nps_rating'