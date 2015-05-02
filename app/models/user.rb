class User < ActiveRecord::Base
  enum team: [:silver, :black, :pink, :red, :orange, :chicken]

  validates_presence_of :team
  
end
