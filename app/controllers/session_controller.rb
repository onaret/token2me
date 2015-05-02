require 'net/ldap'

class SessionController < ApplicationController

  before_action :check_session, :except => [:new, :login]

  def new
    if current_user
      redirect_to tokens_path
    end
  end
  
  def login
    host = 'ldap.axway.int'
    port =  389
    path = "ou=Employees,dc=axway,dc=int"
    ident, psw = "#{params[:name]}@axway.com", params[:password]

    ldap = Net::LDAP.new    :host => host,
          :port => "389", 
          :base => path,
          :auth => {
            :method => :simple,
            :username => ident,
            :password => psw 
          }

    result_attrs = ["sAMAccountName", "displayname", "mail"]

    # Build filter
    search_filter = Net::LDAP::Filter.eq("sAMAccountName", params[:name])

    # Execute search
    #ldap.search(:filter => search_filter, :attributes => result_attrs, :return_result => false) do |item| 
    #   username = item.sAMAccountName.first 
    #    notice = "Connected as #{username}: #{item.displayName.first} (#{item.mail.first})."
        user = User.where(name: params[:name]).first_or_create
        session[:user_id] = user.id

        if user.team
          redirect_to root_path
        else
          redirect_to edit_user_path(current_user), notice: "Set you team"
        end

    #end

  end

  def logout
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out!"
  end

end
