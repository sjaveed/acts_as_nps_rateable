require File.join(File.dirname(__FILE__), "acts_as_nps_rateable/railtie")

module ActsAsNpsRateable
  autoload :Hook, File.join(File.dirname(__FILE__), "acts_as_nps_rateable/hook")
  autoload :Rateable, File.join(File.dirname(__FILE__), "acts_as_nps_rateable/rateable")
  autoload :Rater, File.join(File.dirname(__FILE__), "acts_as_nps_rateable/rater")
end

require 'nps_rating'