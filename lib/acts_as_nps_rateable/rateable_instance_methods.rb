# These are all the instance methods that acts_as_nps_rateable includes into an ActiveModel

module ActsAsNpsRateable::RateableInstanceMethods
  # rate this rateable ensuring there's at most only one rating per user per rateable
  def rate(score, rater)
    return unless rater.present?

    ActiveRecord::Base.transaction do
      nps_ratings.where(rater: rater).delete_all if rater.present?
      nps_ratings.create(score: score.to_i, rater: rater)
    end
  end

  # the average of all ratings for this rateable
  def average_rating
    nps_ratings.average(:score)
  end

  # a check to see if the specified user has already rated this rateable
  def rated_by?(rater)
    return unless rater.present?

    nps_ratings.where(rater: rater).any?
  end

  #
  # Net Promoter Score Calculations: http://www.checkmarket.com/2011/06/net-promoter-score/
  #

  def promoters ratings = nil
    if ratings.nil?
      nps_ratings.promoters.size
    else
      ratings.promoters.size
    end
  end

  def passives ratings = nil
    if ratings.nil?
      nps_ratings.passives.size
    else
      ratings.passives.size
    end
  end

  def detractors ratings = nil
    if ratings.nil?
      nps_ratings.detractors.size
    else
      ratings.detractors.size
    end
  end

  def net_promoter_score ratings = nil
    total_ratings = ratings.nil? ? nps_ratings.size : ratings.size
    return 0 if total_ratings.zero?

    if ratings.nil?
      (promoters - detractors) * 100 / total_ratings
    else
      (promoters(ratings) - detractors(ratings)) * 100 / total_ratings
    end
  end

end