require 'spec_helper'

describe "the cheering process" do

  before(:each) do
    sign_up_as_god
    add_astronaut_goal
  end

  context "as another user" do
    before(:each) do
      click_button "Sign Out"
      sign_up("Bob")
      visit goal_url(god.goals.first)
    end

    it "cheers" do
      click_button "Cheer"
      expect(page).to have_content "cheered"
      expect(page).to have_content "astronaut"
    end

    it "does not let you cheer the same goal more than once" do
      click_button "Cheer"
      expect(page).not_to have_button "Cheer"
    end

    it "displays the cheerer's username" do
      click_button "Cheer"
      expect(page).to have_content "Bob cheered this"
    end

    it "increments the cheer count" do
      expect(page).to have_content "0 cheer(s)"
      click_button "Cheer"
      expect(page).to have_content "1 cheer(s)"
    end
  end

  it "enforces cheer limit" do
    5.times { add_goal("Purchase #{Faker::Commerce.product_name}") }
    click_button "Sign Out"
    sign_up("Bob")
    god.goals.each do |goal|
      visit goal_url(goal)
      click_button "Cheer"
    end

    expect(page).to have_content "You have run out of cheers."
    expect(page).not_to have_content "Bob cheered this"
  end

end
