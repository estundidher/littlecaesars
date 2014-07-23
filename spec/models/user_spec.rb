require 'rails_helper'

describe User do

  let(:user) { FactoryGirl.build_stubbed :admin}

  subject {user}

  it {should respond_to :username}
  it {should respond_to :email}
  it {should respond_to :password}

  it {should be_valid}
end