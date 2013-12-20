class Goal < ActiveRecord::Base
  attr_accessible :completed, :name, :private

  validates :name, :user, :presence => true

  belongs_to :user
end
