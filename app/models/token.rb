class Token < ActiveRecord::Base
  belongs_to :user
  
  enum status: [ :free, :active, :queued, :archived  ]

  def self.build_token(token_params)
    token = Token.new(token_params)
    token.status = get_current_token_status
    token
  end

  def self.get_current_token_status
    last_status = Token.all.last.status.to_sym
    if last_status== :archived
      :active
    elsif last_status == :active || last_status == :queued
      :queued
    end
  end

  def self.release_token
    active_token = Token.where(status: 1).last
    if active_token
      active_token.status = :archived
      active_token.save
      if active_token != Token.all.last
        next_token = Token.find(active_token.id + 1)
        next_token.status = :active
        next_token.save
      end
    end
  end

  def last_status
    Token.all.last.status
  end

end
