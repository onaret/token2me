class TokenMailer < ApplicationMailer
 
  def you_got_token(user)
    @user = user
    mail(to: @user.email, subject: 'You have the token !')
  end

end
