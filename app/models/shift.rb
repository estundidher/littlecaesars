class Shift < ActiveRecord::Base

  belongs_to :opening_hour

  validates :start_at,
            presence: true

  validate :start_at_cannot_be_before_last_shift_added

  validates :end_at,
            presence: true

  def start_at day=nil
    if(read_attribute(:start_at))
        day = Date.current if day.nil?
        Time.zone.parse("#{day.strftime('%F')} #{read_attribute(:start_at).strftime("%I:%M %p")}")
    end
  end

  def end_at day=nil
    if(read_attribute(:end_at))
        day = Date.current if day.nil?
        Time.zone.parse("#{day.strftime('%F')} #{read_attribute(:end_at).strftime("%I:%M %p")}")
    end
  end

  def range step
    (self.start_at.to_i..self.end_at.to_i).step(step).map {|d| Time.zone.at(d)}
  end

  def to_s
    "start_at: #{self.start_at}, end_at: #{self.end_at}"
  end

  private

    def start_at_cannot_be_before_last_shift_added
      unless self.opening_hour.nil? || self.opening_hour.shifts.empty?
        last = self.opening_hour.shifts.last
        unless last.id == self.id
          if self.read_attribute(:start_at) < last.read_attribute(:end_at)
            self.errors[:start_at] = "Can't be before the last shift added!"
          end
        end
      end
    end
end