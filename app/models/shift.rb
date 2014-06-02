class Shift < ActiveRecord::Base

  belongs_to :opening_hour

  validates :start_at,
            presence: true

  validate :start_at_cannot_be_before_last_shift_added

  validates :end_at,
            presence: true

  def start_at
    if(read_attribute(:start_at))
        read_attribute(:start_at).to_formatted_s(:time)
    end
  end

  def end_at
    if(read_attribute(:end_at))
        read_attribute(:end_at).to_formatted_s(:time)
    end
  end

  private

    def start_at_cannot_be_before_last_shift_added
      unless self.opening_hour.shifts.empty?
        last = self.opening_hour.shifts.last
        #puts "#{'@'*100}> last.id: #{last.id}, self.id: #{self.id}"
        unless last.id == self.id
          if self.read_attribute(:start_at) < last.read_attribute(:end_at)
            #puts "#{'@'*100}> last: #{last.read_attribute(:end_at)}, actual: #{self.read_attribute(:start_at)}"
            self.errors[:start_at] = "Can't be before the last shift added!"
          end
        end
      end
    end
end