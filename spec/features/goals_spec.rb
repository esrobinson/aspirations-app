require 'spec_helper'

describe "goal creation" do
  before(:each) do
    sign_up_as_god
    visit new_goal_url
  end

  it "has a new goal page" do
    expect(page).to have_content("Add a Goal")
    expect(page).to have_content("Goal Name")
    expect(page).to have_content("Private?")
  end

  it "doesn't allow blank goal name" do
    click_button "Add Goal"
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Add a Goal")
    expect(page).to have_content("Goal Name")
    expect(page).to have_content("Private?")
  end

  it "takes you to goal show page on creation" do
    fill_in "Goal Name", :with => "Be an astronaut"
    click_button "Add Goal"
    expect(page).to have_content("Be an astronaut")
  end

end

describe "goal editing" do
  before(:each) do
    sign_up_as_god
    add_astronaut_goal
    add_goal("Mortality", true)
  end

  it "has an edit link on show page" do
    click_link "Edit Goal"
    expect(page).to have_content("Edit Goal")
    expect(page).to have_content("Goal Name")
    expect(page).to have_content("Private?")
  end

  it "has an edit page" do
    goal = god.goals.first
    visit edit_goal_url(goal)
    expect(page).to have_content("Edit Goal")
    expect(page).to have_content("Goal Name")
    expect(page).to have_content("Private?")
  end

  it "populate goal name" do
    goal = god.goals.first
    visit edit_goal_url(goal)
    expect(find_field("Goal Name").value).to eq(goal.name)
  end

  it "shouldn't have private box checked for public goal" do
    goal = god.goals.where(:private => false).first
    visit edit_goal_url(goal)
    expect(find_field("Private?")).not_to be_checked
  end

  it "should have private box checked for private goal" do
    goal = god.goals.where(:private => true).first
    visit edit_goal_url(goal)
    expect(find_field("Private?")).to be_checked
  end

  it "can only be done by the owner" do
    goal = god.goals.first
    click_button "Sign Out"
    sign_up("Bob")
    visit edit_goal_url(goal)
    expect(page).to have_content(
      "You must be the owner of this goal to do that."
    )
    expect(page).not_to have_content("Edit Goal")
  end


  it "displays the new name after editing" do
    goal = god.goals.first
    visit edit_goal_url(goal)
    fill_in "Goal Name", :with => "Be a scuba diver"
    click_button "Edit Goal"
    expect(page).to have_content("Be a scuba diver")
  end

end

describe "goal deletion" do

  before(:each) do
    sign_up_as_god
    add_astronaut_goal
  end

  it "has a delete button on show page" do
    expect(page).to have_button "Give Up"
  end

  it "can only be done by the owner" do
    goal = god.goals.first
    click_button "Sign Out"
    visit goal_url(goal)
    expect(page).not_to have_button "Give Up"
  end

  it "removes goal from list" do
    click_button "Give Up"
    expect(page).not_to have_content "Be an astronaut"
  end

  it "should redirect to user's goal list" do
    click_button "Give Up"
    expect(page).to have_content "Goal List"
    expect(current_path).to eq(user_path(god))
  end

end

describe "goal list" do

  before(:each) do
    sign_up_as_god
    add_astronaut_goal
    add_goal("Mortality", true)
    add_goal("Learn to wrap")
    add_goal("Rapture", true)
    visit user_url(god)
  end


  it "shows the user all of their own goals" do
    expect(page).to have_content("Be an astronaut")
    expect(page).to have_content("Mortality")
    expect(page).to have_content("Learn to wrap")
    expect(page).to have_content("Rapture")
  end

  it "only shows user's own goals" do
    click_button "Sign Out"
    sign_up("Bob")
    add_goal("Quit drinking")
    add_goal("Save my marriage", true)
    click_button "Sign Out"
    sign_in("god")
    expect(page).not_to have_content("Quit drinking")
  end

  it "doesn't show private goals to other users" do
    path = current_path
    click_button "Sign Out"
    sign_up("Bob")
    visit path
    expect(page).not_to have_content("Mortality")
    expect(page).not_to have_content("Rapture")
  end

  it "shows public goals to other users" do
    path = current_path
    click_button "Sign Out"
    sign_up("Bob")
    visit path
    expect(page).to have_content("Be an astronaut")
    expect(page).to have_content("Learn to wrap")
  end

  it "shows completed goals" do
    click_link "Learn to wrap"
    click_link "Edit Goal"
    check "Completed?"
    click_button "Edit Goal"
    expect(page).to have_content("Completed")
  end

  it "doesn't falsely claim completion" do
    expect(page).not_to have_content("Completed")
  end

end

describe "goal show page" do

  before(:each) do
    sign_up_as_god
    add_goal("Mortality", true)
  end

  it "does not let non-owners see private goals" do
    click_button "Sign Out"
    sign_up("Bob")
    visit goal_url(god.goals.first)
    expect(page)
      .to have_content("You must be the owner of this goal to do that.")
  end
end