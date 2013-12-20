require 'spec_helper'

describe "the signup process" do

  it "has a new user page" do
    visit new_user_url
    expect(page).to have_content "Sign Up"
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"
  end

  describe "signing up a user" do

    it "rejects a blank username" do
      visit new_user_url
      fill_in "Password", :with => "Password"
      click_button "Sign Up"
      expect(page).to have_content "Sign Up"
      expect(page).to have_content "Username can't be blank"
    end

    it "rejects a blank password" do
      visit new_user_url
      fill_in "Username", :with => "god"
      click_button "Sign Up"
      expect(page).to have_content "Sign Up"
      expect(page).to have_content "Password can't be blank"
    end

    it "rejects a short password" do
      visit new_user_url
      fill_in "Username", :with => "god"
      fill_in "Password", :with => "pass"
      click_button "Sign Up"
      expect(page).to have_content "Sign Up"
      expect(page).to have_content "Password is too short"
    end

    it "shows the username on the homepage after signup" do
      sign_up_as_god
      expect(page).to have_content "god"
    end

  end

end

describe "logging in" do

  it "redirects to the user's show page on login" do
    sign_up_as_god
    click_button "Sign Out"
    sign_in("god")
    expect(current_path).to eq(user_path(god))
  end

  it "has a sign in page" do
    visit new_session_url
    expect(page).to have_content "Sign In"
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"
  end

  it "returns to new session on failed sign in" do
    visit new_session_url
    fill_in "Username", :with => "NotARealUserName"
    fill_in "Password", :with => "TheWrongPassword"
    click_button "Sign In"
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"
  end

  it "shows username on the next page after login" do
    sign_up_as_god
    click_button "Sign Out"
    sign_in "god"
    expect(page).to have_content "god"
  end

end

describe "logging out" do

  it "begins with logged out state" do
    visit new_goal_url
    expect(current_path).to eq new_session_path
  end

  it "doesn't show username on the homepage after logout" do
    sign_up_as_god
    click_button "Sign Out"
    expect(page).not_to have_content "god"
  end

  it "redirects to login page on logout" do
    sign_up_as_god
    click_button "Sign Out"
    expect(current_path).to eq new_session_path
  end

end