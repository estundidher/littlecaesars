require 'rails_helper'

describe PickUp do

  let(:pick_up) { FactoryGirl.build_stubbed :pick_up}

  subject {pick_up}

  it {should respond_to :cart}
  it {should validate_presence_of :cart}

  it {should respond_to :place}
  it {should validate_presence_of :place}

  it {should respond_to :date}
  it {should validate_presence_of :date}

  it {should be_valid}
end