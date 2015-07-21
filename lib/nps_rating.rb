module ActsAsNpsRateable
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

    def self.calculate_for relevant_ratings
      total_ratings = relevant_ratings.size
      return 0 if total_ratings.zero?

      promoters = relevant_ratings.promoters.size
      detractors = relevant_ratings.detractors.size

      ((promoters - detractors) * 100.0 / total_ratings).round
    end

    def comments= comments
      write_attribute(:comments, comments.present? ? comments : nil)
    end

    def response= response
      if response.present?
        write_attribute(:response, response)
        write_attribute(:responded_at, Time.now)
      end
    end

    def upvote!
      ActsAsNpsRateable::NpsRating.update_counters(id, up_votes: 1, net_votes: 1)
    end

    def downvote!
      ActsAsNpsRateable::NpsRating.update_counters(id, down_votes: 1, net_votes: -1)
    end
  end
end
