class User < ActiveRecord::Base
  enum team: [:silver, :black, :pink, :red, :orange, :chicken]
  
end
