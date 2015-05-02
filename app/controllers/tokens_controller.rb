class TokensController < ApplicationController

  # GET :access_type/tokens
  # GET :access_type/tokens.json
  def index
    if params[:access_type] == 'server'
      access_type=0
    else
      access_type=1
    end
    @tokens = Token.where(access_type: access_type).order(created_at: :desc)

    if Token.free? @tokens
      flash[:notice] = "Token is free"
    elsif Token.active(params[:access_type]).user.team == current_user.team
      flash[:notice] = "<strong>Your team have the token</strong>".html_safe
    else
      flash[:notice] = "Token is is use"
    end
  end

  # GET /tokens/new
  def new
    @token = Token.new
    @token.access_type = params[:access_type]
  end

  # POST :access_type/tokens
  # POST :access_type/tokens.json
  def create
    @token = Token.build_token(token_params)
    @token.access_type = params[:access_type]
    @token.user = current_user
    respond_to do |format|
      if @token.save
        format.html { redirect_to tokens_path(params[:access_type]), notice: 'You have the ' + params[:access_type] + ' token.' }
        format.json { render :show, status: :created, location: tokens_path(params[:access_type]) }
      else
        format.html { render :new }
        format.json { render json: @token.errors, status: :unprocessable_entity }
      end
    end
  end

  def release_token
    Token.release_token params[:access_type]
    redirect_to action: "index"
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def token_params
    params.require(:token).permit(:status, :comment, :user_id, :access_type)
  end

end
