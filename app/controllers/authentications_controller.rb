class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = Authentication.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authentications }
    end
  end

  # GET /authentications/1
  # GET /authentications/1.json
  def show
    @authentication = Authentication.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @authentication }
    end
  end

  # GET /authentications/new
  # GET /authentications/new.json
  def new
    @authentication = Authentication.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @authentication }
    end
  end

  # GET /authentications/1/edit
  def edit
    @authentication = Authentication.find(params[:id])
  end

  # POST /authentications
  # POST /authentications.json
  def create
    # Omniauth passes data here via request.env rather than by params.
    @auth_hash = request.env["omniauth.auth"]
    session[:oauth_token] = @auth_hash['credentials'].token
    @authentication = Authentication.find_by_uid_and_provider(@auth_hash['uid'],@auth_hash['provider'])
    if @authentication.blank?
      @new_user = true
      @user = User.create(email: @auth_hash['info']['email'], username: @auth_hash['info']['name'])
      @authentication = Authentication.create(uid: @auth_hash['uid'],
        provider: @auth_hash['provider'], user_id: @user.id) if @user
    else
      @new_user = false
      @user = @authentication.user
    end # if
  end # def create

  # PUT /authentications/1
  # PUT /authentications/1.json
  def update
    @authentication = Authentication.find(params[:id])

    respond_to do |format|
      if @authentication.update_attributes(params[:authentication])
        format.html { redirect_to @authentication, notice: 'Authentication was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @authentication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy

    respond_to do |format|
      format.html { redirect_to authentications_url }
      format.json { head :no_content }
    end
  end
end
