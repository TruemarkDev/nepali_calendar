# frozen_string_literal: true

require 'spec_helper'
require 'date'

describe NepaliCalendar do
  let(:today) { Date.today }
  let(:bs_date) { NepaliCalendar::BsCalendar.ad_to_bs('2015', '09', '09') }
  let(:ad_date) { NepaliCalendar::AdCalendar.bs_to_ad('2072', '05', '23') }

  it 'counts nepali days' do
    expect(NepaliCalendar::Calendar.total_days_for_bs('2000/03/13', '2000/01/01')).to eq(74)
  end

  it 'counts english days' do
    expect(NepaliCalendar::Calendar.total_days(Date.parse('1944/02/13'), Date.parse('1944/01/01'))).to eq(43)
  end

  it 'has a version number' do
    expect(NepaliCalendar::VERSION).not_to be nil
  end

  it 'BS date does not respond to total_days & ref_date' do
    expect(bs_date).to_not respond_to(:total_days)
    expect(bs_date).to_not respond_to(:ref_date)
  end

  it 'AD date does not respond to date_in_range? and valid_date?' do
    expect(ad_date).to_not respond_to(:date_in_range?)
    expect(ad_date).to_not respond_to(:valid_date?)
  end

  it 'BS date does not respond to date_in_range? and valid_date?' do
    expect(bs_date).to_not respond_to(:date_in_range?)
    expect(bs_date).to_not respond_to(:valid_date?)
  end

  it 'AD date does not respond to date_in_range? and valid_date?' do
    expect(ad_date).to_not respond_to(:date_in_range?)
    expect(ad_date).to_not respond_to(:valid_date?)
  end

  it 'responds to get_ad_date & get_bs_date' do
    expect(NepaliCalendar::AdCalendar).to respond_to(:get_ad_date)
    expect(NepaliCalendar::BsCalendar).to respond_to(:get_bs_date)
  end

  context '#BsCalendar' do
    let(:bs_date_from_invalid_ad_date) { NepaliCalendar::BsCalendar.ad_to_bs('2072', '2', '30') }
    let(:bs_date_from_nil_ad_date) { NepaliCalendar::BsCalendar.ad_to_bs('', '', '') }

    it 'checks validity of ad date to be converted' do
      expect { bs_date_from_invalid_ad_date }.to raise_exception NepaliCalendar::Calendar::InvalidADDateException
      expect { bs_date_from_nil_ad_date }.to raise_exception NepaliCalendar::Calendar::NilDateFieldsException
    end
    it 'converts date from ad_to_bs' do
      expect(bs_date.year).to eq(2072)
      expect(bs_date.month).to eq(5)
      expect(bs_date.day).to eq(23)
      expect(bs_date.wday).to eq(4)
      expect(bs_date.month_name).to eq('Bhadra')
      expect(bs_date.wday_name).to eq('Budhbar')
    end

    it 'returns todays date' do
      d = Date.today
      bs_today = NepaliCalendar::BsCalendar.ad_to_bs(d.year, d.month, d.day)
      expect(bs_today.to_s).to eq(NepaliCalendar::BsCalendar.today.to_s)
    end

    it 'returns beginning of week' do
      d1 = NepaliCalendar::BsCalendar.ad_to_bs(2015, 9, 20).beginning_of_week
      d2 = NepaliCalendar::BsCalendar.ad_to_bs(2015, 9, 19).beginning_of_week
      d3 = NepaliCalendar::BsCalendar.ad_to_bs(2015, 10, 2).beginning_of_week
      d4 = NepaliCalendar::BsCalendar.ad_to_bs(2015, 4, 15).beginning_of_week
      expect(d1.to_s).to eq('Aitabar, 3 Ashwin, 2072')
      expect(d2.to_s).to eq('Aitabar, 27 Bhadra, 2072')
      expect(d3.to_s).to eq('Aitabar, 10 Ashwin, 2072')
      expect(d4.to_s).to eq('Aitabar, 29 Chaitra, 2071')
    end

    it 'returns end of week' do
      d1 = NepaliCalendar::BsCalendar.ad_to_bs(2015, 9, 20).end_of_week
      d2 = NepaliCalendar::BsCalendar.ad_to_bs(2015, 9, 19).end_of_week
      d3 = NepaliCalendar::BsCalendar.ad_to_bs(2015, 9, 28).end_of_week
      expect(d1.to_s).to eq('Sanibar, 9 Ashwin, 2072')
      expect(d2.to_s).to eq('Sanibar, 2 Ashwin, 2072')
      expect(d3.to_s).to eq('Sanibar, 16 Ashwin, 2072')
    end

    it 'returns beginning of month' do
      d1 = NepaliCalendar::BsCalendar.ad_to_bs(2015, 10, 30).beginning_of_month
      expect(d1.to_s).to eq('Aitabar, 1 Kartik, 2072')
    end

    it 'returns end of month' do
      d1 = NepaliCalendar::BsCalendar.ad_to_bs(2015, 10, 20).end_of_month
      expect(d1.to_s).to eq('Sombar, 30 Kartik, 2072')
    end

    it 'returns Calendar class object' do
      d1 = NepaliCalendar::BsCalendar.ad_to_bs(2015, 10, 20).end_of_month
      expect(d1.class).to eq(NepaliCalendar::BsCalendar)
    end
  end

  context '#AdCalendar' do
    let(:ad_date_from_invalid_bs_date) { NepaliCalendar::AdCalendar.bs_to_ad('2072', '10', '30') }
    let(:ad_date_from_nil_bs_date) { NepaliCalendar::AdCalendar.bs_to_ad('', '', '') }

    it 'checks validity of bs date to be converted' do
      expect { ad_date_from_invalid_bs_date }.to raise_exception(NepaliCalendar::Calendar::InvalidBSDateException)
      expect { ad_date_from_nil_bs_date }.to raise_exception(NepaliCalendar::Calendar::NilDateFieldsException)
    end

    let(:ad_date) { NepaliCalendar::AdCalendar.bs_to_ad('2072', '04', '01') }
    it 'converts date from bs_to_ad' do
      expect(ad_date.year).to eq(2015)
      expect(ad_date.month).to eq(7)
      expect(ad_date.day).to eq(17)
      expect(ad_date.wday).to eq(5)
      expect(ad_date.month_name).to eq('July')
      expect(ad_date.wday_name).to eq('Friday')
    end

    it 'returns todays date' do
      d = Date.today
      bs_today = NepaliCalendar::AdCalendar.bs_to_ad(d.year, d.month, d.day)
      expect(bs_today.to_s).to eq(NepaliCalendar::AdCalendar.today.to_s)
    end

    it 'returns beginning of week' do
      d1 = NepaliCalendar::AdCalendar.bs_to_ad(2076, 7, 15).beginning_of_week
      d2 = NepaliCalendar::AdCalendar.bs_to_ad(2076, 9, 19).beginning_of_week
      d3 = NepaliCalendar::AdCalendar.bs_to_ad(2076, 10, 2).beginning_of_week
      d4 = NepaliCalendar::AdCalendar.bs_to_ad(2076, 4, 15).beginning_of_week
      expect(d1).to eq(Date.parse('Mon, 28 Oct, 2019'))
      expect(d2).to eq(Date.parse('Mon, 30 Dec, 2019'))
      expect(d3).to eq(Date.parse('Mon, 13 Jan, 2020'))
      expect(d4).to eq(Date.parse('Mon, 29 Jul, 2019'))
    end

    it 'returns end of week' do
      d1 = NepaliCalendar::AdCalendar.bs_to_ad(2076, 7, 15).end_of_week
      d2 = NepaliCalendar::AdCalendar.bs_to_ad(2076, 9, 19).end_of_week
      d3 = NepaliCalendar::AdCalendar.bs_to_ad(2076, 10, 2).end_of_week
      expect(d1).to eq(Date.parse('Sun, 3 Nov, 2019'))
      expect(d2).to eq(Date.parse('Sun, 5 Jan, 2020'))
      expect(d3).to eq(Date.parse('Sun, 19 Jan, 2020'))
    end

    it 'returns beginning of month' do
      d1 = NepaliCalendar::AdCalendar.bs_to_ad(2076, 7, 15).beginning_of_month
      expect(d1).to eq(Date.parse('Fri, 1 Nov, 2019'))
    end

    it 'returns end of month' do
      d1 = NepaliCalendar::AdCalendar.bs_to_ad(2076, 7, 15).end_of_month
      expect(d1).to eq(Date.parse('Sat, 30 Nov, 2019'))
    end
  end

  context '#FiscalYear' do
    it 'returns start of fiscal year date in BS' do
      start_date = NepaliCalendar::FiscalYear.new(78, 79).beginning_of_year
      expect(start_date.year.to_s).to eq('2078')
      expect(start_date.month.to_s).to eq('4')
      expect(start_date.day.to_s).to eq('1')
    end

    it 'returns end of fiscal year date in BS' do
      start_date = NepaliCalendar::FiscalYear.new(78, 79).end_of_year
      expect(start_date.year.to_s).to eq('2079')
      expect(start_date.month.to_s).to eq('3')
      expect(start_date.day.to_s).to eq('32')
    end

    it 'returns fiscal year date in BS' do
      fiscal_year = NepaliCalendar::FiscalYear.fiscal_year_for_bs_date(2077, 4, 1)
      expect(fiscal_year.to_s).to eq('7778')
      fiscal_year = NepaliCalendar::FiscalYear.fiscal_year_for_bs_date(2077, 3, 29)
      expect(fiscal_year.to_s).to eq('7677')
    end

    it 'returns fiscal year date in BS from AD date' do
      fiscal_year = NepaliCalendar::FiscalYear.fiscal_year_in_bs_for_ad_date(Date.new(2021, 3, 22))
      expect(fiscal_year.to_s).to eq('7778')

      # edge case
      fiscal_year = NepaliCalendar::FiscalYear.fiscal_year_in_bs_for_ad_date(Date.new(2022, 7, 16))
      expect(fiscal_year.to_s).to eq('7879')
    end

    it 'returns the current fiscal year represented as a string' do
      allow(Date).to receive(:today).and_return(Date.new(2022, 5, 26))
      fiscal_year = NepaliCalendar::FiscalYear.current_fiscal_year
      expect(fiscal_year.to_s).to eq('7879')
    end

    it 'returns the next fiscal year' do
      fiscal_year = NepaliCalendar::FiscalYear.new(78, 79).next
      expect(fiscal_year.to_s).to eq('7980')
    end

    it 'returns the list of fiscal years with start date and end date in AD' do
      start_date_ad = Date.new(2020, 8, 1)
      fiscal_years = NepaliCalendar::FiscalYear.fiscal_years_list_in_ad(start_date_ad)

      expect(fiscal_years[0].name).to eq('2077/78')
      expect(fiscal_years[0].start_date).to eq(Date.new(2020,07,16))
      expect(fiscal_years[0].end_date).to eq(Date.new(2021,07,15))

      expect(fiscal_years[1].name).to eq('2078/79')
      expect(fiscal_years[1].start_date).to eq(Date.new(2021,07,16))
      expect(fiscal_years[1].end_date).to eq(Date.new(2022,07,16))

      expect(fiscal_years[2].name).to eq('2079/80')
      expect(fiscal_years[2].start_date).to eq(Date.new(2022,07,17))
      expect(fiscal_years[2].end_date).to eq(Date.new(2023,07,16))

      expect(fiscal_years[3].name).to eq('2080/81')
      expect(fiscal_years[3].start_date).to eq(Date.new(2023,07,17))
      expect(fiscal_years[3].end_date).to eq(Date.new(2024,07,15))
    end
  end

  context '#FiscalYearPeriod' do
    let(:fiscal_year_period) { NepaliCalendar::FiscalYearPeriod.new(start_date: Date.new(2022,07,17), end_date: Date.new(2023,07,16), name: '2079/80') }

    it 'returns the start date' do
      expect(fiscal_year_period.start_date).to eq(Date.new(2022, 7, 17))
    end

    it 'returns the end date' do
      expect(fiscal_year_period.end_date).to eq(Date.new(2023, 7, 16))
    end

    it 'returns the number of days in the fiscal year period' do
      expect(fiscal_year_period.days_in_year).to eq(365)
    end

    it 'returns whether the fiscal year period is current' do
      expect(fiscal_year_period.is_current?).to eq(false)

      fiscal_year_period = NepaliCalendar::FiscalYearPeriod.new(start_date: 200.days.ago, end_date: 165.days.from_now, name: 'test')

      expect(fiscal_year_period.is_current?).to eq(true)
    end
  end
end
