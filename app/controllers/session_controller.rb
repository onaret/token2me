require 'net/ldap'

class SessionController < ApplicationController

  def new
    if current_user
      redirect_to server_token_index_path
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
        user = User.find_by(name: params[:name])
    #    notice = "Connected as #{username}: #{item.displayName.first} (#{item.mail.first})."
        if user
          session[:user_id] = user.id
          redirect_to root_path, notice: notice
        else
          user = User.create(name: params[:name])
          session[:user_id] = user.id
          redirect_to edit_user_path(current_user)
        end

    #end

  end

  def logout
    session[:user_id] = nil
    redirect_to root_path, :notice => "Logged out!"
  end

end
