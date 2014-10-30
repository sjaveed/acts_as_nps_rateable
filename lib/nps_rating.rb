module ActsAsNpsRateable
  class NpsRating < ActiveRecord::Base
    self.table_name = 'nps_ratings'

    belongs_to :nps_rateable, polymorphic: true
    belongs_to :user

    validates_presence_of :score
    validates_numericality_of :score, only_integer: true
    validates_inclusion_of :score, in: (0..10).to_a, message: 'must be between 0 and 10'

    validates_presence_of :nps_rateable_id
    validates_presence_of :nps_rateable_type

    validates_presence_of :user_id
    validates_uniqueness_of :user_id, scope: [:nps_rateable_type, :nps_rateable_id], message: 'has already rated'

    before_save :remove_blank_comments

    scope :promoters, lambda { where(score: [9, 10]) }
    scope :passives, lambda { where(score: [7, 8]) }
    scope :detractors, lambda { where('score <= 6') }
    scope :with_comments, lambda { where('comments IS NOT NULL') }

    def self.calculate_for relevant_ratings
      total_ratings = relevant_ratings.size
      return 0 if total_ratings == 0

      promoters = relevant_ratings.promoters.size
      detractors = relevant_ratings.detractors.size

      ((promoters - detractors) * 100.0 / total_ratings).round
    end

    private

    def remove_blank_comments
      write_attribute(:comments, nil) if comments.blank?
    end
  end
end
