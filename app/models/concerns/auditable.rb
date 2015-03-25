module Auditable
  extend ActiveSupport::Concern

  included do
    belongs_to :created_by, foreign_key:'created_by', class_name:'User'
    belongs_to :updated_by, foreign_key:'updated_by', class_name:'User'

    validates :created_by,
              presence: true

    validates :updated_by,
              presence: true,
              on: :update

    before_validation :audit!
  end

private
    def audit!
      if self.id
        self.updated_by = User.current
      else
        self.created_by = User.current
      end
    end
end