# These are all the instance methods that acts_as_nps_rater includes into an ActiveModel

module ActsAsNpsRateable::RaterInstanceMethods
  # rate this rateable ensuring there's at most only one rating per user per rateable
  def rate(rateable, score)
    ActiveRecord::Base.transaction do
      nps_ratings.where(nps_rateable: rateable).delete_all
      nps_ratings.create(nps_rateable: rateable, score: score.to_i)
    end
  end

  # the average of all ratings given by this rater
  def average_rating
    nps_ratings.average(:score)
  end

  # a check to see if this rater has already rated the specified rateable
  def rated?(rateable)
    return unless rateable.present?

    nps_ratings.where(nps_rateable: rateable).any?
  end

  def rating_for(rateable)
    return unless rateable.present?

    nps_ratings.where(nps_rateable: rateable).first
  end
end