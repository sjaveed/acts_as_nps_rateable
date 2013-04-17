module ActsAsNpsRateable
  class Railtie < Rails::Railtie
    # Extend ActiveRecord::Base here and include ActsAsNpsRateable instance methods
    config.to_prepare do
      ActiveRecord::Base.send(:extend, ActsAsNpsRateable::Hook)
    end
  end
end