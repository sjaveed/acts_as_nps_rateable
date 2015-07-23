##
# acts_as_nps_rateable is a library that provides the following functionality:
# * Net Promoter Score recording and analysis functionality.
# * Storing comments in addition to a rating
# * One response per comment from the entity being reviewed
# * Upvoting or downvoting comments (as many times as someone wants)
#
# These are all the instance methods that <code>acts_as_nps_rateable</code> includes into a model
module ActsAsNpsRateable::Rateable
  ##
  # Rate this rateable ensuring there's at most only one rating per rater per rateable
  #
  # @param [Integer] score
  #   This is the actual rating this rateable is getting
  # @param [ActsAsNpsRateable::Rater] rater
  #   This is the rater who is rating this particular rateable.  Nothing happens if this is absent.
  def rate(score, rater)
    return unless rater.present?

    ActiveRecord::Base.transaction do
      ratings_by(rater).delete_all
      nps_ratings.create(score: score.to_i, rater: rater)
    end
  end

  ##
  # Returns the average of all ratings for this rateable
  #
  # @return [Float] the average of all ratings for this rateable
  #   This uses the database average aggregation
  def average_rating
    nps_ratings.average(:score)
  end

  ##
  # Checks whether a rater has already rated this rateable
  #
  # @param [ActsAsNpsRateable::Rater] rater
  #   The rater who might have rated this rateable before
  #
  # @return [Boolean] if a rater was specified
  # @return nil if rater is nil
  def rated_by?(rater)
    return unless rater.present?

    ratings_by(rater).any?
  end

  ##
  # Get the rating given to this rateable by a rater
  #
  # @param [ActsAsNpsRateable::Rater] rater
  #   The rater who might have rated this rateable before.
  #
  # @return [Boolean] if a rater was specified
  # @return nil if rater is nil
  def rating_by(rater)
    return unless rater.present?

    ratings_by(rater).first
  end

  ##
  # Returns the number of ratings which are classified as promoters.  Promoters are any ratings where the score is
  # greater than 8
  #
  # @param [ActiveRecord::Relation<ActsAsNpsRateable::NpsRating>] ratings
  #   These are optional ratings - typically a subset of the whole - which you want to calculate the promoter count from
  # @return [Integer] the number of promoter ratings among all the ratings for this rateable if ratings is nil
  # @return [Integer] the number of promoter ratings among the given ratings if ratings is not nil
  def promoters ratings = nil
    if ratings.nil?
      nps_ratings.promoters.size
    else
      ratings.promoters.size
    end
  end

  ##
  # Returns the number of ratings which are classified as passives.  Passives are any ratings where the score is
  # either 7 or 8
  #
  # @param [ActiveRecord::Relation<ActsAsNpsRateable::NpsRating>] ratings
  #   These are optional ratings - typically a subset of the whole - which you want to calculate the passive count from
  # @return [Integer] the number of passive ratings among all the ratings for this rateable if ratings is nil
  # @return [Integer] the number of passive ratings among the given ratings if ratings is not nil
  def passives ratings = nil
    if ratings.nil?
      nps_ratings.passives.size
    else
      ratings.passives.size
    end
  end

  ##
  # Returns the number of ratings which are classified as detractors.  Passives are any ratings where the score is
  # less than 7
  #
  # @param [ActiveRecord::Relation<ActsAsNpsRateable::NpsRating>] ratings
  #   These are optional ratings - typically a subset of the whole - which you want to calculate the detractor count from
  # @return [Integer] the number of detractor ratings among all the ratings for this rateable if ratings is nil
  # @return [Integer] the number of detractor ratings among the given ratings if ratings is not nil
  def detractors ratings = nil
    if ratings.nil?
      nps_ratings.detractors.size
    else
      ratings.detractors.size
    end
  end

  ##
  # Calculates the Net Promoter Score as defined at http://www.checkmarket.com/2011/06/net-promoter-score/
  #
  # @param [ActiveRecord::Relation<ActsAsNpsRateable::NpsRating>] ratings
  #   These are optional ratings - typically a subset of the whole - which you want to calculate the Net Promoter Score
  #   from
  # @return [Integer] the Net Promoter Score based on all the ratings for this rateable if ratings is nil
  # @return [Integer] the Net Promoter Score based on the given ratings if ratings is not nil
  def net_promoter_score ratings = nil
    total_ratings = ratings.nil? ? nps_ratings.size : ratings.size
    return 0 if total_ratings.zero?

    if ratings.nil?
      (promoters - detractors) * 100 / total_ratings
    else
      (promoters(ratings) - detractors(ratings)) * 100 / total_ratings
    end
  end

  ##
  # Add an optional review to this rateable only if this rater has previously rated this rateable.
  #
  # @param [String] comment
  #   The actual comment
  # @param [ActsAsNpsRateable::Rater] rater
  #   This is the rater who is rating this particular rateable.  Nothing happens if this is absent.
  def review(comment, rater)
    return unless rater.present?

    ratings_by(rater).update_all(comments: comment)
  end

  private

  ##
  # A convenience method to DRY up the logic of fetching all ratings for this rateable by a given rater
  #
  # @param [ActsAsNpsRateable::Rater] rater
  #   This is the rater for whom you want ratings retrieved
  # @return [ActiveRecord::Relation<ActsAsNpsRateable::NpsRating>]
  #   the list of ratings by the rater for this rateable
  def ratings_by(rater)
    nps_ratings.where(rater: rater)
  end

end