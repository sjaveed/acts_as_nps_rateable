# These are all the instance methods that acts_as_nps_rater includes into an ActiveModel

module ActsAsNpsRateable::Rater
  ##
  # As this rater, rate the specified rateable ensuring there's at most only one rating per rater per rateable
  #
  # @param [ActsAsNpsRateable::Rateable] rateable
  #   This is the rateable which this rater is rating.  Nothing happens if this is absent.
  # @param [Integer] score
  #   This is the actual rating this rater is giving
  def rate(rateable, score)
    ActiveRecord::Base.transaction do
      ratings_for(rateable).delete_all
      nps_ratings.create(nps_rateable: rateable, score: score.to_i)
    end
  end

  ##
  # Returns the average of all ratings this rater has ever given
  #
  # @return [Float] the average of all ratings this rater has given
  #   This uses the database average aggregation
  def average_rating
    nps_ratings.average(:score)
  end

  ##
  # Checks whether this rater has already rated a rateable
  #
  # @param [ActsAsNpsRateable::Rateable] rateable
  #   The rateable that this rater might have rated before
  #
  # @return [Boolean] if a rateable was specified
  # @return nil if rater is nil
  def rated?(rateable)
    return unless rateable.present?

    ratings_for(rateable).any?
  end

  ##
  # Get the rating this rater has given to a rateable
  #
  # @param [ActsAsNpsRateable::Rateable] rateable
  #   The rateable that this rater might have rated before.
  #
  # @return [Boolean] if a rateable was specified
  # @return nil if rater is nil
  def rating_for(rateable)
    return unless rateable.present?

    ratings_for(rateable).first
  end

  ##
  # Add an optional review by this rater to a rateable only if this rater has previously rated that rateable
  #
  # @param [String] comment
  #   The actual comment
  # @param [ActsAsNpsRateable::Rateable] rateable
  #   This is the rateable for which this rater is adding a review.  Nothing happens if this is absent.
  def review(comment, rateable)
    return unless rateable.present?

    ratings_for(rateable).update_all(comment: comment)
  end

  private

  ##
  # A convenience method to DRY up the logic of fetching all ratings by this rater for a given rateable
  #
  # @param [ActsAsNpsRateable::Rateable] rateable
  #   This is the rateable for which you want ratings retrieved
  # @return [ActiveRecord::Relation<ActsAsNpsRateable::NpsRating>]
  #   the list of ratings for the rateable by this rater
  def ratings_for(rateable)
    nps_ratings.where(nps_rateable: rateable)
  end
end