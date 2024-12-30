# frozen_string_literal: true

module NepaliCalendar
  class FiscalYear
    attr_accessor :start_year, :end_year

    def initialize(start_year, end_year)
      @start_year = start_year
      @end_year = end_year
    end

    # returns start of fiscal year date in BS
    def beginning_of_year
      start_date = "20#{start_year}"
      NepaliCalendar::BsCalendar.new(nil, { year: start_date, month: 4, day: 1 })
    end

    # returns end of fiscal year date in BS
    def end_of_year
      end_date = "20#{end_year}" 
      NepaliCalendar::BsCalendar.new(nil, { year: end_date, month: 3, day: NepaliCalendar::BS[end_date.to_i][3] })
    end

    def next
      NepaliCalendar::FiscalYear.new(end_year, (end_year.to_i + 1).to_s)
    end

    def is_current_fiscal_year?
      start_year == self.class.current_fiscal_year.start_year && end_year == self.class.current_fiscal_year.end_year
    end

    # returns fiscal year date in BS
    # (2079, 2, 12) ==> 7879
    def self.fiscal_year_for_bs_date(bs_year, bs_month, bs_day)
      bs_date = NepaliCalendar::BsCalendar.new(nil, { year: bs_year, month: bs_month, day: bs_day })
      fiscal_year = if bs_date.month < 4
                      (bs_date.year - 1).to_s.slice(2, 2).to_s + bs_date.year.to_s.slice(2, 2).to_s
                    else
                      bs_date.year.to_s.slice(2, 2).to_s + (bs_date.year + 1).to_s.slice(2, 2).to_s
                    end
      NepaliCalendar::FiscalYear.new(fiscal_year.to_s.slice(0, 2), fiscal_year.to_s.slice(2, 2))
    end

    # [date] -> This is a Date object (and obviously represents AD date)
    # Returns the fiscal year represented as a string in the form of 7778.
    def self.fiscal_year_in_bs_for_ad_date(date)
      bs_date = NepaliCalendar::BsCalendar.ad_to_bs(date.year.to_s, date.month.to_s, date.day.to_s)
      fiscal_year = if bs_date.month < 4
                      (bs_date.year - 1).to_s.slice(2, 2).to_s + bs_date.year.to_s.slice(2, 2).to_s
                    else
                      bs_date.year.to_s.slice(2, 2).to_s + (bs_date.year + 1).to_s.slice(2, 2).to_s
                    end
      NepaliCalendar::FiscalYear.new(fiscal_year.to_s.slice(0, 2), fiscal_year.to_s.slice(2, 2))
    end

    # Returns the  current fiscal year represented as a string in the form of 7778.
    def self.current_fiscal_year
      bs_date_today = NepaliCalendar::BsCalendar.ad_to_bs(Date.today.year, Date.today.month, Date.today.day)
      fiscal_year = if bs_date_today.month < 4
                      (bs_date_today.year - 1).to_s.slice(2, 2) + bs_date_today.year.to_s.slice(2, 2)
                    else
                      bs_date_today.year.to_s.slice(2, 2) + (bs_date_today.year + 1).to_s.slice(2, 2)
                    end

      NepaliCalendar::FiscalYear.new(fiscal_year.to_s.slice(0, 2), fiscal_year.to_s.slice(2, 2))
    end

    def self.fiscal_years_list_in_ad(start_date_ad)
      start_date_bs = NepaliCalendar::BsCalendar.ad_to_bs(start_date_ad.year, start_date_ad.month, start_date_ad.day)
      upto_year = current_fiscal_year.next
      fiscal_years = []

      fiscal_year = fiscal_year_in_bs_for_ad_date(Date.new(start_date_ad.year, start_date_ad.month, start_date_ad.day))

      loop do
        start_date = fiscal_year.beginning_of_year
        end_date = fiscal_year.end_of_year
    
        start_date_ad = NepaliCalendar::AdCalendar.bs_to_ad(start_date.year, start_date.month, start_date.day)
        end_date_ad = NepaliCalendar::AdCalendar.bs_to_ad(end_date.year, end_date.month, end_date.day)
        fiscal_year_name = "#{start_date.year}/#{end_date.year.to_s.slice(2, 2)}"
    
        fiscal_years.append(NepaliCalendar::FiscalYearPeriod.new(
          start_date: Date.new(start_date_ad.year, start_date_ad.month, start_date_ad.day),
          end_date: Date.new(end_date_ad.year, end_date_ad.month, end_date_ad.day),
          name: fiscal_year_name
        ))

        break if fiscal_year.start_year == upto_year.start_year

        fiscal_year = fiscal_year.next
      end
    
      fiscal_years
    end

    # Should return the '7879' form of string.
    def to_s
      start_year.to_s + end_year.to_s
    end
  end
end
