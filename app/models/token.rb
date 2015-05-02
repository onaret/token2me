class Token < ActiveRecord::Base
  belongs_to :user
  
  enum status: [ :free, :active, :queued, :archived  ]
  enum access_type: [ :server, :ui ]

  def self.free?(token_list)
    token_list.first.archived?
  end

  def self.build_token(token_params, access_type)
    token = Token.new(token_params)
    token.access_type = access_type
    token.status = get_next_status(access_type)
    token
  end

  def self.active_team(access_type)
    Token.active(access_type).user.team 
  end

  def self.release_token(access_type)
    active_token = active(access_type)
    active_token.update(status: :archived)
    if active_token != last_token(access_type)
      next_token = Token.find_by(access_type: Token.access_types[access_type], id: active_token.id + 1)
      next_token.update(status: :active)
  #  else
  #    next_token = Token.new.save
    end
  end

  def self.get_next_status(access_type)
    last_status= last_token(access_type).status.to_sym
    if last_status == :archived
      :active
    elsif last_status == :active || last_status == :queued
      :queued
    end
  end

  def self.list(access_type)
    Token.where(access_type: Token.access_types[access_type]).order(created_at: :desc)
  end
  
  def self.last_token(access_type)
    Token.where(access_type: Token.access_types[access_type]).last
  end

  def self.active(access_type)
    Token.find_by(access_type: Token.access_types[access_type], status: 1)
  end

end
