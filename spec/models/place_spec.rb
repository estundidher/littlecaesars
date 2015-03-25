require 'rails_helper'

describe Place do

  let(:place) { FactoryGirl.build_stubbed :hillarys }

  subject {place}

  it {should respond_to :name}
  it {should validate_presence_of :name}
  it {should ensure_length_of(:name).is_at_most 30}
#  it {should validate_uniqueness_of :name}

  it {should respond_to :address}
  it {should validate_presence_of :address}
  it {should ensure_length_of(:address).is_at_most 100}
#  it {should validate_uniqueness_of :address}

  it {should respond_to :phone}
  it {should validate_presence_of :phone}
  it {should ensure_length_of(:phone).is_at_most 30}
#  it {should validate_uniqueness_of :phone}

  it {should respond_to :description}
  it {should validate_presence_of :description}
#  it {should ensure_length_of(:description).is_at_most 100}

  it {should respond_to :map}
  it {should ensure_length_of(:map).is_at_most 500}
#  it {should validate_uniqueness_of :map}

  it {should have_many :opening_hours}

  it {should be_valid}
end