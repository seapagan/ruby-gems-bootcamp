module Schedulable
  extend ActiveSupport::Concern
  included do
    # List course days
    DAYS_OF_WEEK = [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday,
                    :sunday]

    # json column to store days of week
    store_accessor :days, *DAYS_OF_WEEK

    # Cast days to/from booleans
    DAYS_OF_WEEK.each do |day|
      scope day, -> { where('days @> ?', { day => true }.to_json) }
      define_method(:"#{day}=") { |value| super ActiveRecord::Type::Boolean.new.cast(value) }
      define_method(:"#{day}?") { send(day) }
    end

    def active_days # Where value true
      DAYS_OF_WEEK.select { |day| send(:"#{day}?") }.compact
    end
  end
end
