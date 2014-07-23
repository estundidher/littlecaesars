require 'rails_helper'

describe Product do

  let(:product) {FactoryGirl.build_stubbed :smashing_pumpkins}

  subject {product}

  it {should respond_to :type}
  it {should validate_presence_of :type}

  it {should have_and_belong_to_many :categories}

  it {should have_and_belong_to_many :items}
  it {should have_many :sizes}

  it {should respond_to :price}

  it {should respond_to :name}
  it {should validate_presence_of :name}
  it {should ensure_length_of(:name).is_at_most 50}

  it {should respond_to :description}
  it {should ensure_length_of(:description).is_at_most 200}

  it {should have_attached_file :photo}
  it {should have_attached_file :photo_left}
  it {should have_attached_file :photo_right}
  it {should have_attached_file :photo_showcase}

  it 'should respond to #to_param' do
    expect(subject.to_param).to eq [subject.id, subject.name.parameterize].join("-")
  end

  it 'should have at least one category' do
    expect(subject.categories.length).to eq 1
  end

  it {should be_valid}
end