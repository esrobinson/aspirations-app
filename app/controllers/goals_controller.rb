class GoalsController < ApplicationController
  before_filter :require_login
  before_filter :require_owner, :only => [:edit, :update, :destroy]

  def show
    @goal = Goal.find(params[:id])
    @cheers = @goal.cheers.includes(:user)
    if @goal.private?
      require_owner
    else

      render :show
    end
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(params[:goal])
    @goal.user = current_user

    if @goal.save
      flash[:messages] = ["You created a goal! Good job!"]
      redirect_to goal_url(@goal)
    else
      flash.now[:messages] = @goal.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @goal.update_attributes(params[:goal])
      flash[:messages] = ["You updated a goal. Kudos!!"]
      redirect_to goal_url(@goal)
    else
      flash.now[:messages] = @goal.errors.full_messages
      render :edit
    end
  end

  def destroy
    @goal.destroy
    flash[:messages] = ["You gave up on a goal! Nice!"]
    redirect_to user_url(current_user)
  end

  def is_owner?
    @goal = Goal.find(params[:id])
    @goal.user == current_user
  end

  private
  def require_owner
    unless is_owner?
      flash[:messages] = ["You must be the owner of this goal to do that."]
      redirect_to user_url(current_user)
    end
  end
end
