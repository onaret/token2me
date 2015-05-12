class TokenMailer < ApplicationMailer
 
  def you_got_token(user, access_type)
    @user = user
    @access_type = access_type
    mail(to: @user.email, subject: "You have the #{access_type} token !")
  end

  def people_asked_token(user, access_type)
    @user = user
    @access_type = access_type
    mail(to: @user.email, subject: "#{user.name} is waiting for the #{access_type} token !")
  end

end
