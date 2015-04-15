class TokensController < ApplicationController

  # GET /tokens
  # GET /tokens.json
  def index
    @tokens = Token.all.order(created_at: :desc)
    @last_token_status = Token.all.last.status
  end

  # GET /tokens/new
  def new
    @token = Token.new
  end

  # POST /tokens
  # POST /tokens.json
  def create
    @token = Token.build_token(token_params)
    @token.user = User.all.first
    respond_to do |format|
      if @token.save
        format.html { redirect_to tokens_path, notice: 'Token was successfully created.' }
        format.json { render :show, status: :created, location: tokens_path }
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
      params.require(:token).permit(:status, :comment, :user_id)
    end
end
