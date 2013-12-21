require 'spec_helper'

describe User do
  subject(:u) { FactoryGirl.build(:user) }

  it { should allow_mass_assignment_of(:username) }
  it { should allow_mass_assignment_of(:password) }
  it { should_not allow_mass_assignment_of(:password_digest) }
  it { should_not allow_mass_assignment_of(:session_token) }
  it { should ensure_length_of(:password).is_at_least(6) }
  it { should have_many(:goals) }
  it { should have_many(:cheers) }
  it { should have_many(:cheered_goals) }

  it "does not allow duplicate usernames" do
    u.save!
    should validate_uniqueness_of(:username)
  end

  describe "::find_by_credentials" do
    before(:each) do
      u.save!
    end

    it "finds a user with valid credentials" do
      user = User.find_by_credentials(
        { :username => u.username, :password => u.password }
      )
      expect(user).to eq(u)
    end

    it "doesn't find a user invalid credentials" do
      user = User.find_by_credentials(
        { :username => "no_name", :password => "wrong_pass" }
      )
      expect(user).to be_nil
    end
  end

  describe "#is_password?" do

    it "confirms correct password" do
      expect(u.is_password?(u.password)).to be_true
    end

    it "rejects incorrect password" do
      expect(u.is_password?("wrong_pass")).to be_false
    end
  end

  describe "#password=" do
    it "should set a password digest" do
      expect(u.password_digest).not_to be_nil
    end
  end

  describe "#reset_session_token" do
    it "creates a session_token" do
      expect(u.session_token).to be_nil
      u.reset_session_token
      expect(u.session_token).not_to be_nil
    end

    it "changes a session_token" do
      u.reset_session_token
      old_token = u.session_token
      u.reset_session_token
      expect(u.session_token).not_to eq(old_token)
    end

    it "doesn't save to database" do
      u.reset_session_token
      expect(u.persisted?).to be_false
    end

  end

  describe "#reset_session_token!" do
    it "saves a new session_token" do
      u.save!
      u.reset_session_token!
      user = User.find_by_session_token(u.session_token)
      expect(user).to eq(u)
    end

    # it "calls #reset_session_token" do
    #   expect(u).to receive(:reset_session_token)
    #   u.reset_session_token!
    # end
  end

  it "does not store plaintext password" do
    u.save!
    expect(User.first.password).to be_nil
  end


end
