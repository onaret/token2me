class Token < ActiveRecord::Base
  belongs_to :user

   enum status: [ :active, :archived, :pending, :free ]
end
