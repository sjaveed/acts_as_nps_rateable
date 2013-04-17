# These are all the instance methods that acts_as_nps_rateable includes into an ActiveModel

module ActsAsNpsRateable::InstanceMethods
  # rate this rateable ensuring there's at most only one rating per user per rateable
  def rate(score, user)
    ActiveRecord::Base.transaction do
      ratings.where(user_id: user.id).delete_all if user.present?
      ratings.create(score: score.to_i, user_id: user.id)
    end
  end

  # the average of all ratings for this rateable
  def average_rating
    ratings.average(:score)
  end

  # a check to see if the specified user has already rated this rateable
  def rated_by?(user)
    return unless user.present?

    ratings.where(user_id: user.id).size > 0
  end

  #
  # Net Promoter Score Calculations: http://www.checkmarket.com/2011/06/net-promoter-score/
  #

  def promoters
    ratings.where(score: [9, 10]).size
  end

  def passives
    ratings.where(score: [7, 8]).size
  end

  def detractors
    ratings.where('score <= ?', 6).size
  end

  def net_promoter_score
    total_ratings = ratings.size
    return 0 if total_ratings == 0

    (promotors - detractors) * 100 / total_ratings
  end

end