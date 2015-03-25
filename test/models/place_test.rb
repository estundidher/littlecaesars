require 'test_helper'
require 'delorean'

class PlaceTest < ActiveSupport::TestCase

  test 'Place has 7 days available' do

    hillarys = places(:hillarys)

    expected = [Date.parse('31th May 2014'),
                Date.parse('1st Jun 2014'),
                Date.parse('2nd Jun 2014'),
                Date.parse('3th Jun 2014'),
                Date.parse('4th Jun 2014'),
                Date.parse('5th Jun 2014'),
                Date.parse('6th Jun 2014')]

    Delorean.time_travel_to Time.parse("2014-05-31 11:00:01 A.M.")

    assert hillarys.dates_available == expected, "expecting #{expected}, received: #{hillarys.dates_available}"
  end

  test 'Place has opening hour for today' do

    hillarys = places(:hillarys)

    day = Time.parse("2014-05-31 11:00:01 A.M.")

    assert hillarys.opening_hour_of(day).day_of_week == 'Saturday'
  end

  test 'Place has times available for day of week with one shift' do

    hillarys = places(:hillarys)

    expected = [Time.parse("2014-05-31 11:30 A.M."),
                Time.parse("2014-05-31 11:45 A.M."),
                Time.parse("2014-05-31 12:00 P.M."),
                Time.parse("2014-05-31 12:15 P.M."),
                Time.parse("2014-05-31 12:30 P.M."),
                Time.parse("2014-05-31 12:45 P.M."),
                Time.parse("2014-05-31 01:00 P.M."),
                Time.parse("2014-05-31 01:15 P.M."),
                Time.parse("2014-05-31 01:30 P.M."),
                Time.parse("2014-05-31 01:45 P.M."),
                Time.parse("2014-05-31 02:00 P.M.")]

    day = Time.parse("2014-05-31 11:00:01 A.M.")

    Delorean.time_travel_to Time.parse("2014-05-31 11:00:01 A.M.")

    result = hillarys.times_available(day)

    assert expected == result, "expecting #{expected}, received: #{result}"
  end

  test 'Place has times available for day of week with two shifts' do

    hillarys = places(:hillarys)

    expected = [Time.parse("2014-05-26 11:30:00 A.M."),
                Time.parse("2014-05-26 11:45:00 A.M."),
                Time.parse("2014-05-26 12:00:00 P.M."),
                Time.parse("2014-05-26 12:15:00 P.M."),
                Time.parse("2014-05-26 12:30:00 P.M."),
                Time.parse("2014-05-26 12:45:00 P.M."),
                Time.parse("2014-05-26 01:00:00 P.M."),
                Time.parse("2014-05-26 01:15:00 P.M."),
                Time.parse("2014-05-26 01:30:00 P.M."),
                Time.parse("2014-05-26 01:45:00 P.M."),
                Time.parse("2014-05-26 02:00:00 P.M."),

                Time.parse("2014-05-26 05:00:00 P.M."),
                Time.parse("2014-05-26 05:15:00 P.M."),
                Time.parse("2014-05-26 05:30:00 P.M."),
                Time.parse("2014-05-26 05:45:00 P.M."),
                Time.parse("2014-05-26 06:00:00 P.M."),
                Time.parse("2014-05-26 06:15:00 P.M."),
                Time.parse("2014-05-26 06:30:00 P.M."),
                Time.parse("2014-05-26 06:45:00 P.M."),
                Time.parse("2014-05-26 07:00:00 P.M."),
                Time.parse("2014-05-26 07:15:00 P.M."),
                Time.parse("2014-05-26 07:30:00 P.M.")]

    day = Time.parse("2014-05-26 11:00:00 A.M.")

    Delorean.time_travel_to Time.parse("2014-05-26 11:00:00 A.M.")

    result = hillarys.times_available(day)

    assert result == expected, "expecting #{expected}, received: #{result}"
  end

  test 'Place has times available for day of week with two shifts from middle of the day' do

    hillarys = places(:hillarys)

    expected = [Time.parse("2014-05-26 01:15 P.M."),
                Time.parse("2014-05-26 01:30 P.M."),
                Time.parse("2014-05-26 01:45 P.M."),
                Time.parse("2014-05-26 02:00 P.M."),

                Time.parse("2014-05-26 05:00 P.M."),
                Time.parse("2014-05-26 05:15 P.M."),
                Time.parse("2014-05-26 05:30 P.M."),
                Time.parse("2014-05-26 05:45 P.M."),
                Time.parse("2014-05-26 06:00 P.M."),
                Time.parse("2014-05-26 06:15 P.M."),
                Time.parse("2014-05-26 06:30 P.M."),
                Time.parse("2014-05-26 06:45 P.M."),
                Time.parse("2014-05-26 07:00 P.M."),
                Time.parse("2014-05-26 07:15 P.M."),
                Time.parse("2014-05-26 07:30 P.M.")]

    day = Time.parse("2014-05-26 01:00:00 P.M.")

    Delorean.time_travel_to Time.parse("2014-05-26 01:00:00 P.M.")

    result = hillarys.times_available(day)

    assert result == expected, "expecting #{expected}, received: #{result}"
  end

  test 'Place has times available from the middle of the day' do

    hillarys = places(:hillarys)

    expected = [Time.parse("2014-06-09 05:00 P.M."),
                Time.parse("2014-06-09 05:15 P.M."),
                Time.parse("2014-06-09 05:30 P.M."),
                Time.parse("2014-06-09 05:45 P.M."),
                Time.parse("2014-06-09 06:00 P.M."),
                Time.parse("2014-06-09 06:15 P.M."),
                Time.parse("2014-06-09 06:30 P.M."),
                Time.parse("2014-06-09 06:45 P.M."),
                Time.parse("2014-06-09 07:00 P.M."),
                Time.parse("2014-06-09 07:15 P.M."),
                Time.parse("2014-06-09 07:30 P.M.")]

    day = Time.parse("2014-06-09 04:37 P.M.")

    Delorean.time_travel_to Time.parse("2014-06-09 04:37 P.M.")

    result = hillarys.times_available(day)

    assert result == expected, "expecting #{expected}, received: #{result}"
  end

end