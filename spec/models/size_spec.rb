require 'rails_helper'

describe Size do

  let(:size) { FactoryGirl.build_stubbed :big_caesars}

  subject {size}

  it {should respond_to :name}
  it {should validate_presence_of :name}
  it {should ensure_length_of(:name).is_at_most 30}

  it {should respond_to :description}
  it {should validate_presence_of :description}
  it {should ensure_length_of(:description).is_at_most 100}

  it 'should respond to #to_param' do
    expect(subject.to_param).to eq [subject.id, subject.name.parameterize].join("-")
  end

  it {should be_valid}
end