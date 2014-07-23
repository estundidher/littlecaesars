require 'rails_helper'

describe Cart do
  let(:cart) { FactoryGirl.build :cart}
  subject {cart}
  it {should respond_to :customer}
  it {should validate_presence_of :customer}
  it {should respond_to :pick_up}
  it {should respond_to :status}
  it {should validate_presence_of :status}
  it {should have_many :items}
  it {should be_valid}
end