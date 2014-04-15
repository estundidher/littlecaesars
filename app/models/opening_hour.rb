class OpeningHour < ActiveRecord::Base
  include Auditable

  belongs_to :place
  has_many :shifts, dependent: :destroy

  accepts_nested_attributes_for :shifts

  validates :place,
            presence: true

  validates :day_of_week,
            presence: true,
            uniqueness: {scope: :place, message: "should have one Opening Hour per Day of Week per Place!"}

  def dates_available
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
end