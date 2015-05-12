class TokensController < ApplicationController

  # GET :access_type/tokens
  # GET :access_type/tokens.json
  def index
    @tokens = Token.list(params[:access_type])

    if Token.free? @tokens
      flash[:notice] = "The token is free"
    elsif Token.active_team(params[:access_type]) == current_user.team
      flash[:notice] = "<strong>Your team have the token</strong>".html_safe
    else
      flash[:notice] = "The token is in use"
    end
  end

  # GET /tokens/new
  def new
    @token = Token.new
    respond_to do |format|
       format.js{}
    end
  end

  # POST :access_type/tokens
  # POST :access_type/tokens.json
  def create
    @token = Token.build_token token_params, params[:access_type]
    @token.user = current_user
    if Token.team_has_no_token? params[:access_type], current_user.team
      @token.save
      if @token.queued?
        begin
          TokenMailer.people_asked_token(Token.active_user(params[:access_type]), params[:access_type]).deliver_later
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
          notice[:alert]="issue delivering mail to next user"      
        end
      end
    end
    redirect_to tokens_path(params[:access_type])
  end

  def release_token
    Token.release_token params[:access_type]
    active_user = Token.active_user params[:access_type]
    redirect_to action: "index"
    if active_user && active_user.email
      begin
        TokenMailer.you_got_token(Token.active_user(params[:access_type]), params[:access_type]).deliver_later
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        notice[:alert]="issue delivering mail to next user"      
      end
    end
  end

  def reset_token
    Token.reset_token params[:access_type]
    redirect_to action: "index"
  end

  def cancel_request
    Token.cancel_request params[:access_type], current_user.team
    redirect_to action: "index"
  end
  
  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def token_params
    params.require(:token).permit(:status, :comment, :user_id, :access_type)
  end

end
