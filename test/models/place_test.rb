require 'test_helper'
require 'delorean'

class PlaceTest < ActiveSupport::TestCase

  test 'Place has 7 days available' do

    hillarys = places(:hillarys)

    Delorean.time_travel_to(Time.parse("2014-05-31 11:00:01 A.M."))

    expected = [Date.parse('31th May 2014'),
                Date.parse('1st Jun 2014'),
                Date.parse('2nd Jun 2014'),
                Date.parse('3th Jun 2014'),
                Date.parse('4th Jun 2014'),
                Date.parse('5th Jun 2014'),
                Date.parse('6th Jun 2014'),
                Date.parse('7th Jun 2014')]

    assert hillarys.dates_available == expected
  end

  test 'Place has opening hour for today' do

    Delorean.time_travel_to(Time.parse('2014-05-31 11:00:01 A.M.'))

    hillarys = places(:hillarys)

    assert hillarys.opening_hour_of_today.day_of_week == 'Saturday'
  end

  test 'Place has times available for day of week with one shift' do

    Delorean.time_travel_to(Time.parse('2014-05-31 11:00:01 A.M.'))

    hillarys = places(:hillarys)

    expected = ['11:30 AM',
                '11:45 AM',
                '12:00 PM',
                '12:15 PM',
                '12:30 PM',
                '12:45 PM',
                '01:00 PM',
                '01:15 PM',
                '01:30 PM',
                '01:45 PM',
                '02:00 PM']

    assert hillarys.times_available == expected
  end

  test 'Place has times available for day of week with two shifts' do

    Delorean.time_travel_to(Time.parse("2014-05-26 11:00:01 A.M."))

    hillarys = places(:hillarys)

    expected = ['11:30 AM',
                '11:45 AM',
                '12:00 PM',
                '12:15 PM',
                '12:30 PM',
                '12:45 PM',
                '01:00 PM',
                '01:15 PM',
                '01:30 PM',
                '01:45 PM',
                '02:00 PM',

                '05:00 PM',
                '05:15 PM',
                '05:30 PM',
                '05:45 PM',
                '06:00 PM',
                '06:15 PM',
                '06:30 PM',
                '06:45 PM',
                '07:00 PM',
                '07:15 PM',
                '07:30 PM']

    assert hillarys.times_available == expected, "expecting #{expected}, received: #{hillarys.times_available}"
  end

end