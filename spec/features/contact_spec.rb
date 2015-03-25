require 'rails_helper'

describe 'contact page' do
  it 'Not filling in the Form' do
    visit '/contact'
    click_button 'btn_send'
    expect(page).to have_selector '.alert-danger', text:"Name can't be blank"
  end
end