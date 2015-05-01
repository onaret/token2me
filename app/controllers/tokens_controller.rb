class TokensController < ApplicationController

  # GET :access_type/tokens
  # GET :access_type/tokens.json
  def index
    @tokens = Token.where(access_type: params[:access_type]).order(created_at: :desc)
    if Token.free?
      flash[:notice] = "Token is free"
    elsif Token.active.user.team == current_user.team
      flash[:notice] = "<strong>Your team have the token</strong>".html_safe
    else
      flash[:notice] = "Token is is use"
    end
  end

  # GET /tokens/new
  def new
    @token = Token.new
  end

  # POST :access_type/tokens
  # POST :access_type/tokens.json
  def create
    @token = Token.build_token(token_params)
    @token = params[:access_type]
    @token.user = current_user
    respond_to do |format|
      if @token.save
        if @token.access_type == 'server'
          format.html { redirect_to server_token_index_path, notice: 'You have the token.' }
          format.json { render :show, status: :created, location: server_token_index_path }
        else
          format.html { redirect_to ui_token_index_path, notice: 'You have the token.' }
          format.json { render :show, status: :created, location: ui_token_index_path }
        end
      else
        format.html { render :new }
        format.json { render json: @token.errors, status: :unprocessable_entity }
      end
    end
  end

  def release_token
    Token.release_token
    @tokens = Token.all.order(created_at: :desc)
    @last_token_status = Token.all.last.status
    redirect_to action: "index"
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def token_params
    params.require(:token).permit(:status, :comment, :user_id, :access_type)
  end

end
