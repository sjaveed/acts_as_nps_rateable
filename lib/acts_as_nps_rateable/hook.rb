# This is the hook that implements the acts_as_nps_rateable method
# and includes all acts_as_nps_rateable instance methods as needed

module ActsAsNpsRateable::Hook
  def acts_as_nps_rateable
    has_many :nps_ratings, class_name: "NpsRating", :as => :nps_rateable, :dependent => :destroy

    include ActsAsNpsRateable::InstanceMethods
  end
end