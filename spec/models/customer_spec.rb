require 'rails_helper'

describe Customer do

  let(:customer) { FactoryGirl.build_stubbed :customer}

  subject {customer}

  it {should respond_to :email}
  it {should validate_presence_of :email}

  it {should respond_to :password}
  it {should validate_presence_of :password}

  it {should respond_to :name}
  it {should validate_presence_of :name}

  it {should respond_to :surname}
  it {should validate_presence_of :surname}

  it {should respond_to :mobile}
  it {should validate_presence_of :mobile}

  it {should respond_to :cart}

  it 'should respond to #full_name' do
    expect(subject.full_name).to eq [subject.name, subject.surname].join(" ")
  end

  it {should be_valid}
end