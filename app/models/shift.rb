class Shift < ActiveRecord::Base

  belongs_to :opening_hour

  validates :start_at,
            presence: true

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
end