require 'rails_helper'

feature 'Admin: Product Types' do
  background do
    @user = create(:admin)
  end
  feature 'Create' do
    scenario 'with invalid params' do
      visit_product_type @user
      click_link 'New Product Type'
      click_button 'Create'
      expect(page).to have_content "Name can't be blank"
    end
    scenario 'with valid params' do
      visit_product_type @user
      click_link 'New Product Type'
      fill_in 'product_type[name]', with:'Ingredients'
      click_button 'Create'
      expect(page).to have_content 'Product Type was successfully created'
    end
  end

  feature 'Update' do
    background do
      @ingredient = create(:ingredient)
    end
    scenario 'with invalid params' do
      visit_product_type @user
      find('.edit').click
      fill_in 'product_type[name]', with:''
      click_button 'Update'
      expect(page).to have_content "Name can't be blank"
    end
    scenario 'with valid params' do
      visit_product_type @user
      find('.edit').click
      fill_in 'product_type[name]', with:'Ingredients updated'
      click_button 'Update'
      expect(page).to have_content 'Product Type was successfully updated'
    end
  end

  feature 'Delete' do
    background do
      @ingredient = create(:ingredient)
    end
    scenario 'with valid params' do
      visit_product_type @user
      find('.delete').click
      expect(page).to have_content 'Product Type was successfully deleted'
    end
  end

  feature 'Show' do
    background do
      @ingredient = create(:ingredient)
    end
    scenario 'with valid params' do
      visit_product_type @user
      find('.view').click
      expect(page).to have_content 'Ingredient'
    end
  end
end