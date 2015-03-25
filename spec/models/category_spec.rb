require 'rails_helper'

describe Category do

  let(:category) { FactoryGirl.build_stubbed :vegetarian}

  subject {category}

  it {should respond_to :name}
  it {should validate_presence_of :name}

  it {should respond_to :created_by}
  it {should validate_presence_of :created_by}

  it {should respond_to :created_at}

  it 'should respond to #to_param' do
    expect(subject.to_param).to eq [subject.id,subject.name.parameterize].join("-")
  end

  it {should be_valid}
end