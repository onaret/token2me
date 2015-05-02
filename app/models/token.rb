class Token < ActiveRecord::Base
  belongs_to :user
  
  enum status: [ :free, :active, :queued, :archived  ]
  enum access_type: [ :server, :ui ]

  def self.free_init?(access_type)
    Token.where(access_type: access_type.to_sym).last.archived?
  end

  def self.free?(token_list)
    token_list.first.archived?
  end


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

  def last_status
    Token.all.last.status
  end

  def self.release_token(access_type)
    active_token = Token.active(access_type)
    active_token.status = :archived
    active_token.save
    if active_token != Token.all.last
      next_token = Token.find(active_token.id + 1)
      next_token.status = :active
      next_token.save
    end
  end

  def self.active(access_type)
    if access_type == 'server'
      access_type=0
    else
      access_type=1
    end

    Token.find_by(access_type: access_type, status: 1)
  end

end
