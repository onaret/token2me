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
    ident_full, psw = "#{params[:ident]}@axway.com", params[:password]

    ldap = Net::LDAP.new    :host => host,
          :port => "389", 
          :base => path,
          :auth => {
            :method => :simple,
            :username => ident_full,
            :password => psw 
          }

    result_attrs = ["sAMAccountName", "displayname", "mail"]

    # Build filter
    search_filter = Net::LDAP::Filter.eq("sAMAccountName", params[:ident])

    # Execute search     
#   ldap.search(:filter => search_filter, :attributes => result_attrs, :return_result => false) do |item| 
      # notice = "Connected as #{username}: #{item.displayName.first} (#{item.mail.first})."
      
      #Wokrkaround waiting LDAP

      item = {
        sAMAccountName: {first: params[:ident]}, 
        displayName: {first: params[:ident]}, 
        mail: {first: ident_full}
      }

      username = item[:sAMAccountName][:first]
      #username = item.sAMAccountName.first 

      #NB : I think user.ident is initialized here if the user is new
      user = User.where(ident: username).first_or_initialize
      
      unless user.id
        user.name = item[:displayName][:first]
        #user.name = item.displayName.first
        user.email = item[:mail][:first]
        #user.email = item.mail.first
        user.save
      end
      
      session[:user_id] = user.id
      redirect_to root_path

   #end

  end

  def logout
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out!"
  end

end
