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
    now = Date.current.strftime('%F')

    self.shifts.each do |shift|
      from = Time.parse("#{now} #{shift.start_at}")
      to = Time.parse("#{now} #{shift.end_at}")
      times += (from.to_i..to.to_i).step(15.minutes).map {|d| Time.zone.at(d)}

      logger.info "Times: #{times}"
    end

    logger.info "Time: #{time}, Time.current: #{Time.current}, Date.current: #{Date.current}"

    if time.to_date == Date.current
      logger.info "time.to_date == Date.current: true.."
      times = times.reject {|x| x.to_i < Time.current.to_i}
    end

    times.map{ |date| date.strftime("%I:%M %p") }
  end

  private
    def after_initialize
      self.shifts.build if self.shifts.nil?
    end
end