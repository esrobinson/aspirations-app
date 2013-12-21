class CheersController < ApplicationController

  before_filter :can_cheer?

  def create
    @cheer = Cheer.new
    @cheer.goal = @goal
    @cheer.user = current_user
    @cheer.save!
    redirect_to goal_url(@cheer.goal)
  end

  private
  def can_cheer?
    @goal = Goal.find(params[:goal_id])
    cheer_count = current_user.cheers.count
    unless cheer_count < 5
      flash[:messages] = ["You have run out of cheers."]
      redirect_to goal_url(@goal)
    end
    if current_user.cheered_goals.include?(@goal)
      redirect_to goal_url(@goal)
    end
  end

end
