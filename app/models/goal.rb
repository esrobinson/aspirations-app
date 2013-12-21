class Goal < ActiveRecord::Base
  attr_accessible :completed, :name, :private

  validates :name, :user, :presence => true

  belongs_to :user

  def private?
    self.private
  end

  def completed?
    self.completed
  end

end
