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
    to = from + 6.days
    dates =* from..to
  end

  def times_available time
    #puts "#{'@'*100}> day.to_s: #{time.to_s}"
    opening_hour = self.opening_hour_of time
    opening_hour.times_available time
  end

  def opening_hour_of_today
    opening_hour_of Date.today
  end

  def opening_hour_of day
    self.opening_hours.find{|opening_hour| opening_hour.day_of_week == day.strftime("%A")}
  end
end