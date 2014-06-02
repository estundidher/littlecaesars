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
    from = Date.today
    to = from + 7.days
    dates =* from..to
  end

  def times_available
    opening_hour = self.opening_hour_of_today

    times = []
    now = Date.today.strftime('%F')

    opening_hour.shifts.each do |shift|

      from = Time.parse("#{now} #{shift.start_at}")
      to = Time.parse("#{now} #{shift.end_at}")

      times += (from.to_i..to.to_i).step(15.minutes).to_a.map{ |date| Time.at(date).strftime("%I:%M %p") }
    end
    times
  end

  def opening_hour_of_today
    self.opening_hours.find{|opening_hour| opening_hour.day_of_week == Date.today.strftime("%A")}
  end
end