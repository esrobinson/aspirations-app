class Goal < ActiveRecord::Base
  attr_accessible :completed, :name, :private

  validates :name, :user, :presence => true

  belongs_to :user
  has_many :cheers
  has_many :cheerers, :through => :cheers, :source => :user

  def private?
    self.private
  end

  def completed?
    self.completed
  end

end
