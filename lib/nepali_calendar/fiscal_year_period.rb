# frozen_string_literal: true

module NepaliCalendar
  class FiscalYearPeriod
    attr_reader :start_date, :end_date, :name

    def initialize(start_date:, end_date:, name:)
      @start_date = start_date
      @end_date = end_date
      @name = name
    end

    def days_in_year
      (end_date - start_date).to_i + 1
    end
  end
end
