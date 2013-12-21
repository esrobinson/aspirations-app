class Cheer < ActiveRecord::Base

  validates :user, :goal, :presence => true

  belongs_to :user
  belongs_to :goal
end
