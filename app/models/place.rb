class Place < ActiveRecord::Base
  include Auditable

  has_many :opening_hours,
           dependent: :destroy

  has_attached_file :photo,
                    styles: {large:'400x450>', medium:'300x300>', thumb:'100x100>'},
                    default_url: '/images/:style/missing.png'

  validates :name,
            presence: true,
            length: {maximum: 30},
            uniqueness: true

  validates :address,
            presence: true,
            length: {maximum: 100},
            uniqueness: true

  validates :phone,
            presence: true,
            length: {maximum: 30},
            uniqueness: true

  validates :description,
            presence: true,
            length: {maximum: 100}

  validates :map,
            length: {maximum: 500},
            uniqueness: true

  validates_attachment :photo,
                       content_type: {content_type:['image/jpg', 'image/jpeg', 'image/gif', 'image/png']},
                       size: {in: 0..500.kilobytes}

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def dates_available
    dates = []
    day = Date.current
    while dates.length < 6 do
      opening_hour = opening_hour_of(day)
      unless opening_hour.nil?
        puts "opening_hour '#{opening_hour.day_of_week}': end_at: #{opening_hour.shifts.last.end_at(day)}, current: #{Time.current}"
        if opening_hour.shifts.last.end_at(day).to_i > Time.current.to_i
          dates << day
        end
      end
      day += 1.day
    end
    dates
  end

  def times_available time
    opening_hour = self.opening_hour_of time
    opening_hour.times_available time
  end

  def opening_hour_of_today
    opening_hour_of Date.current
  end

  def opening_hour_of day
    self.opening_hours.find{|opening_hour| opening_hour.day_of_week == day.strftime("%A")}
  end
end