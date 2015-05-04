class Token < ActiveRecord::Base
  belongs_to :user
  
  enum status: [ :free, :queued, :active, :archived ]
  enum access_type: [ :server, :ui ]

  validates_presence_of :status, :access_type

  scope :of_access_type, -> (access_type) {where(access_type:  Token.access_types[access_type])}
  scope :of_status, -> (status) {where(status: Token.statuses[status])}
# scope :active_token_for, -> (access_type) {find_by(access_type: Token.access_types[access_type], status: Token.statuses[:active])}

# scope :active_token_for, -> (access_type) {find_by(access_type: Token.access_types[access_type], status: Token.statuses[:active])}
# scope :active_token_for, -> (access_type) {where(access_type: Token.access_types[access_type], status: Token.statuses[:active]).first}


  def self.free?(token_list)
    unless token_list.empty?
      token_list.first.archived?
    else
      none
    end
  end

  def self.build_token(token_params, access_type)
    token = Token.new(token_params)
    token.access_type = access_type
    token.status = get_next_status access_type
    token
  end

  def self.active_user(access_type)
    active_token = active_token_for(access_type)
    if active_token
      active_token.user
    end
  end

  def self.active_team(access_type)
    active_user = active_user(access_type)
    if active_user
      active_user.team
    end
  end

  def self.release_token(access_type)
    active_token = active_token_for(access_type)
    if active_token
      active_token.update(status: :archived)
      if last_token(access_type).queued?
        Token.of_access_type(access_type).of_status(:queued).order(id: :asc).first.update(status: :active)
      end
    end
  end

  def self.reset_token(access_type)
    of_access_type(access_type).destroy_all
  end

  def self.get_next_status(access_type)
    if of_access_type(access_type).empty?
      :active
    else
      last_status= last_token(access_type).status.to_sym
      if last_status == :archived
        :active
      elsif last_status == :active || last_status == :queued
        :queued
      end
    end
  end

  def self.list(access_type)
    of_access_type(access_type).order(id: :desc)
  end
  
  def self.last_token(access_type)
    of_access_type(access_type).last
  end

  def self.team_is_in_queued?(access_type, team)
    !of_access_type(access_type).of_status(:queued).joins(:user).merge(User.where(team: User.teams[team])).empty?
  end

  def self.cancel_request(access_type, team)
    of_access_type(access_type).of_status(:queued).joins(:user).merge(User.where(team: User.teams[team])).destroy_all
  end

  def self.active_token_for(access_type)
    find_by(access_type: Token.access_types[access_type], status: Token.statuses[:active])
  end

end
