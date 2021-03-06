class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @goals = @user.goals
    @goals.reject! { |goal| goal.private? } if @user != current_user
  end

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      login!(@user)
      flash[:messages] = ["Signed up successfully!"]
      redirect_to user_url(@user)
    else
      flash.now[:messages] = @user.errors.full_messages
      render :new
    end
  end

end
