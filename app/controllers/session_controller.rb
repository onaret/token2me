require 'net/ldap'

class SessionController < ApplicationController

  before_action :check_session, :except => [:new, :login]

  def new
    if current_user && current_user.team
      redirect_to tokens_path
    elsif current_user
      redirect_to edit_user_path(current_user), notice: "Set you team"
    end
  end
  
  def login
    host = 'ldap.axway.int'
    port =  389
    path = "ou=Employees,dc=axway,dc=int"
    ident_full = "#{params[:ident]}@axway.com"

    ldap = Net::LDAP.new    :host => host,
          :port => "389", 
          :base => path,
          :auth => {
            :method => :simple,
            :username => ident_full,
            :password => params[:password] 
          }

    result_attrs = ["sAMAccountName", "displayname", "mail", "team"]

    # Build filter
    search_filter = Net::LDAP::Filter.eq("sAMAccountName", params[:ident])

    # Execute search     
    ldap.search(:filter => search_filter, :attributes => result_attrs, :return_result => false) do |item| 
      #notice = "Connected as #{username}: #{item.displayName.first} (#{item.mail.first})."
      username = item.sAMAccountName.first 
      user = User.where(ident: username).first_or_initialize
      user.name = item.displayName.first
      user.email = item.mail.first
      #user.team = item.team.first.to_sym
      user.save
      session[:user_id] = user.id
    end
    redirect_to root_path

  end

  def logout
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out!"
  end

end
