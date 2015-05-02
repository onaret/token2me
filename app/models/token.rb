class Token < ActiveRecord::Base
  belongs_to :user
  
  enum status: [ :free, :queued, :active, :archived ]
  enum access_type: [ :server, :ui ]

  scope :of_access_type, -> (access_type) {where(access_type:  Token.access_types[access_type])}
  scope :of_status, -> (status) {where(status: Token.statuses[status])}
#  scope :active_token_for, -> (access_type) {find_by(access_type: Token.access_types[access_type], status: Token.statuses[:active])}
#  scope :active_token_for, -> (access_type) {where(access_type: Token.access_types[access_type], status: Token.statuses[:active]).first}


  def self.free?(token_list)
    unless token_list.empty?
      token_list.first.archived?
    end
  end

  def self.build_token(token_params, access_type)
    token = Token.new(token_params)
    token.access_type = access_type
    token.status = get_next_status access_type
    token
  end

  def self.active_team(access_type)
    unless Token.of_access_type(access_type).empty? 
      Token.active_token_for(access_type).user.team 
    end
  end

  def self.release_token(access_type)
    active_token = active_token_for(access_type)
    active_token.update(status: :archived)
    if last_token(access_type).queued?
      next_token = Token.of_access_type(access_type).of_status(:queued).order(id: :asc).first.update(status: :active)
  #  else
  #    next_token = Token.new.save
    end
  end

  def self.reset_token(access_type)
    Token.of_access_type(access_type).destroy_all
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
    Token.of_access_type(access_type).order(id: :desc)
  end
  
  def self.last_token(access_type)
    Token.of_access_type(access_type).last
  end

  def self.active_token_for(access_type)
    Token.find_by(access_type: Token.access_types[access_type], status: Token.statuses[:active])
  end


end
