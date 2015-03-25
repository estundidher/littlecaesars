module Touchable
  extend ActiveSupport::Concern

private
  def force_touch record
    unless self.new_record?
      self.touch
    end
  end
end