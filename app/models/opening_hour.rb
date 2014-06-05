class OpeningHour < ActiveRecord::Base
  include Auditable

  belongs_to :place
  has_many :shifts,
           dependent: :destroy

  accepts_nested_attributes_for :shifts,
                                allow_destroy: true
  validates :place,
            presence: true

  validates :day_of_week,
            presence: true,
            uniqueness: {scope: :place, message: 'should have one Opening Hour per Day of Week per Place!'}

  def remaining_dates
    if self.place.opening_hours
      if self.day_of_week
        Date::DAYNAMES - self.place.opening_hours.map{|h| h.day_of_week} + [self.day_of_week]
      else
        Date::DAYNAMES - self.place.opening_hours.map{|h| h.day_of_week}
      end
    else
      Date::DAYNAMES - self.place.opening_hours.map{|h| h.day_of_week}
    end
  end

  def times_available time
    times = []
    times = self.shifts.map{|shift| shift.range(15.minutes)}.flatten
    if time.to_date == Date.current
      times = times.reject {|x| x.to_i < (Time.now + 15.minutes).to_i}
    end
    times
  end

  private
    def after_initialize
      self.shifts.build if self.shifts.nil?
    end
end