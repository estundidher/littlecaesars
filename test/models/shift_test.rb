require 'test_helper'

class ShiftTest < ActiveSupport::TestCase

  test 'should refuse new shift before last added' do

    opening_hour = opening_hours(:mundaring_monday)

    shift = Shift.new opening_hour: opening_hour, start_at: Time.parse('2000-01-01 17:00:01 UTC'), end_at:Time.parse('2000-01-01 18:00:01 UTC')

    assert_not shift.save, "Invalid shift saved!"

    assert_equal ["Can't be before the last shift added!"], shift.errors[:start_at]
  end

  test 'should not accept new shift before last added' do

    opening_hour = opening_hours(:mundaring_monday)

    shift = Shift.new opening_hour: opening_hour, start_at: Time.parse('2000-01-01 10:00:01 A.M.'), end_at:Time.parse('2000-01-01 15:00:01 P.M.')

    assert_not shift.save, "Invalid shift added!"

    assert_equal ["Can't be before the last shift added!"], shift.errors[:start_at]
  end

  test 'should not accept new shift after last added with multiple shifts' do

    opening_hour = opening_hours(:mundaring_wednesday)

    shift = Shift.new opening_hour: opening_hour, start_at: Time.parse('2000-01-01 03:00:01 A.M.'), end_at:Time.parse('2000-01-01 18:00:01 P.M.')

    assert_not shift.save, "Invalid shift added!"

    assert_equal ["Can't be before the last shift added!"], shift.errors[:start_at]
  end

  test 'should not accept new shift after last added in a row' do

    opening_hour = opening_hours(:mundaring_tuesday)

    opening_hour.shifts.create(start_at: Time.parse('2000-01-01 11:00:01 A.M.'), end_at:Time.parse('2000-01-01 14:00:01 P.M.'))
    opening_hour.shifts.create(start_at: Time.parse('2000-01-01 17:00:01 P.M.'), end_at:Time.parse('2000-01-01 18:00:01 P.M.'))
    opening_hour.shifts.create(start_at: Time.parse('2000-01-01 03:00:01 A.M.'), end_at:Time.parse('2000-01-01 18:00:01 P.M.'))

    assert_not opening_hour.save, "Invalid shift has been added!"

    assert_equal ["Can't be before the last shift added!"], opening_hour.errors['shifts.start_at']
  end

  test 'should accept new shift with no last shift added' do

    opening_hour = opening_hours(:mundaring_tuesday)

    shift = Shift.new opening_hour: opening_hour, start_at: Time.parse('2000-01-01 17:00:01 P.M.'), end_at:Time.parse('2000-01-01 18:00:01 P.M.')

    assert shift.save, "Should have been saved!"
  end

end