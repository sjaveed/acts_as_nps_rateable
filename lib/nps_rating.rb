##
# acts_as_nps_rateable is a library that provides the following functionality:
# * Net Promoter Score recording and analysis functionality.
# * Storing comments in addition to a rating
# * One response per comment from the entity being reviewed
# * Upvoting or downvoting comments (as many times as someone wants)
module ActsAsNpsRateable
  ##
  # This is the actual model that stores a rating, a review (if any), its response (if any) and a count of upvotes and
  # downvotes
  class NpsRating < ActiveRecord::Base
    self.table_name = 'nps_ratings'

    belongs_to :nps_rateable, polymorphic: true
    belongs_to :rater, polymorphic: true

    validates_presence_of :score
    validates_numericality_of :score, only_integer: true
    validates_inclusion_of :score, in: (0..10).to_a, message: 'must be between 0 and 10'

    validates_presence_of :nps_rateable
    validates_presence_of :rater
    validates_uniqueness_of :rater_id, scope: [:rater_type, :nps_rateable_type, :nps_rateable_id], message: 'has already rated'

    scope :promoters, lambda { where(score: [9, 10]) }
    scope :passives, lambda { where(score: [7, 8]) }
    scope :detractors, lambda { where(NpsRating.arel_table[:score].lteq(6)) }

    scope :with_comments, lambda { where.not(comments: nil) }

    ##
    # Returns the Net Promoter Score for the given collection of ratings.
    #
    # @param [ActiveRecord::Relation<NpsRating>] relevant_ratings
    #   This is essentially the result of an ActiveRecord query for nps_ratings
    #
    # @example
    #   NpsRating.calculate_for(fancy_product.nps_ratings)
    #
    # @return [Float] The calculated Net Promoter Score.
    #   This is 0 if <code>relevant_ratings.size</code> is 0
    def self.calculate_for relevant_ratings
      total_ratings = relevant_ratings.size
      return 0 if total_ratings.zero?

      promoters = relevant_ratings.promoters.size
      detractors = relevant_ratings.detractors.size

      ((promoters - detractors) * 100.0 / total_ratings).round
    end

    ##
    # @!attribute [w] comments
    #   Ensures that any comments that are recorded are non-blank
    def comments= comments
      write_attribute(:comments, comments.present? ? comments : nil)
    end

    ##
    # @!attribute [w] response
    #   Ensures that when a non-blank response is recorded, the responded_at time is also updated to the current time
    def response= response
      if response.present?
        write_attribute(:response, response)
        write_attribute(:responded_at, Time.now)
      end
    end

    ##
    # Upvotes a rating atomically.  Duplicate votes are possible.
    def upvote!
      ActsAsNpsRateable::NpsRating.update_counters(id, up_votes: 1, net_votes: 1)
    end

    ##
    # Downvotes a rating atomically.  Duplicate votes are possible.
    def downvote!
      ActsAsNpsRateable::NpsRating.update_counters(id, down_votes: 1, net_votes: -1)
    end
  end
end
