require 'rails_helper'

describe Order do

  let(:order) { FactoryGirl.build_stubbed :order }

  subject {order}

  it {should respond_to :state}
  it {should validate_presence_of :state}

  it {should respond_to :customer}
  it {should validate_presence_of :customer}

  it {should respond_to :pick_up}
  it {should validate_presence_of :pick_up}

  it {should respond_to :ip_address}
  it {should validate_presence_of :ip_address}

  it {should be_valid}
end