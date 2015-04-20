class SessionController < ApplicationController
  
  def login
    host = 'ldap.axway.int'
    port =  389
    path = "ou=Employees,dc=axway,dc=int"
    user, psw = "#{params[:signin][:name]}@axway.com", params[:signin][:password]

    ldap = Net::LDAP.new    :host => host,
          :port => "389", 
          :base => path,
          :auth => {
            :method => :simple,
            :username => user,
            :password => psw 
          }

    result_attrs = ["sAMAccountName", "displayname", "mail"]

    # Build filter
    search_filter = Net::LDAP::Filter.eq("sAMAccountName", params[:name])

    # Execute search
    #ldap.search(:filter => search_filter, :attributes => result_attrs, :return_result => false) do |item| 
    #   username = item.sAMAccountName.first 
        username = user #TODELETE
        user = User.find_or_create_by(name:  user)
    #    notice = "Connected as #{username}: #{item.displayName.first} (#{item.mail.first})."
        session[:user_id] = user.id
    #end

    redirect_to root_path, notice: notice
  end

  def logout
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

  def new
    if current_user
      redirect_to tokens_path
    end
  end
end
