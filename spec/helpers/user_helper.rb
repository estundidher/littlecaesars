module  UserHelper

  def login(a)
    visit admin_root_path
    expect(page).to have_content "You need to sign in or sign up before continuing."
    fill_in 'user[username]', with:a.username
    fill_in 'user[password]', with:a.password
    click_button 'Sign in'
  end

  def logout(a)
    visit admin_root_path
    click_link 'admin@caesars.com'
    click_link 'Sign Out'
  end

end