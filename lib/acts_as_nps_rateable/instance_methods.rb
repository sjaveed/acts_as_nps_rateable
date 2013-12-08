# These are all the instance methods that acts_as_nps_rateable includes into an ActiveModel

module ActsAsNpsRateable::InstanceMethods
  # rate this rateable ensuring there's at most only one rating per user per rateable
  def rate(score, user)
    ActiveRecord::Base.transaction do
      nps_ratings.where(user_id: user.id).delete_all if user.present?
      nps_ratings.create(score: score.to_i, user_id: user.id)
    end
  end

  # the average of all ratings for this rateable
  def average_rating
    nps_ratings.average(:score)
  end

  # a check to see if the specified user has already rated this rateable
  def rated_by?(user)
    return unless user.present?

    nps_ratings.where(user_id: user.id).size > 0
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
    return 0 if total_ratings == 0

    if ratings.nil?
      (promoters - detractors) * 100 / total_ratings
    else
      (promoters(ratings) - detractors(ratings)) * 100 / total_ratings
    end
  end

end