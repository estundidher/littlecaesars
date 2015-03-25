require 'rails_helper'

describe ProductType do

  let(:product_type) { FactoryGirl.build_stubbed :pizza}

  subject {product_type}

  it {should respond_to :name}
  it {should validate_presence_of :name}
  it {should ensure_length_of(:name).is_at_most 50}
  it {should respond_to :created_by}
  it {should validate_presence_of :created_by}

  it {should respond_to :created_at}

  it 'shoud be priceable if not sizable' do
    subject.sizable = false
    expect(subject.priceable?).to be true
  end

  it 'shoud be quantitable if not additionable' do
    subject.additionable = false
    expect(subject.quantitable?).to be true
  end

  it 'shoud not be priceable if sizable' do
    subject.sizable = true
    expect(subject.priceable?).to be false
  end

  it 'shoud not be quantitable if additionable' do
    subject.additionable = true
    expect(subject.quantitable?).to be false
  end

  it {should be_valid}

end