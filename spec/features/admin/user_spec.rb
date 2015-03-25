require 'rails_helper'

feature 'Admin: User' do
  background do
    @user = create(:admin)
  end
  feature 'After Sign In' do
    background do
      login(@user)
    end
    scenario 'displays greeting message' do
      expect(page).to have_content 'Signed in successfully.'
    end
    scenario 'displays correct links available' do
      within('.navbar-nav.menu') do
        expect(page).to have_link 'Product Types'
        expect(page).to have_link 'Categories'
        expect(page).to have_link 'Sizes'
        expect(page).to have_link 'Products'
        expect(page).to have_link 'Places'
        expect(page).to have_link 'Users'
        expect(page).to have_link 'Customers'
        expect(page).to have_link 'Chefs'
      end
    end
  end
  feature 'After Sign Out' do
    scenario 'displays home banner' do
      login @user
      click_link 'admin'
      click_link 'Sign Out'
      expect(page).to have_content '2010 World Champion Pizza Maker Las Vegas'
    end
  end
end