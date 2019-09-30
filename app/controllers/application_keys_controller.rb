class ApplicationKeysController < ApplicationController
  before_action :set_application_key, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /application_keys
  # GET /application_keys.json
  def index
    @application_keys = ApplicationKey.all
  end

  # GET /application_keys/1
  # GET /application_keys/1.json
  def show
  end

  # GET /application_keys/new
  def new
    @application_key = ApplicationKey.new
  end

  # GET /application_keys/1/edit
  def edit
  end

  # POST /application_keys
  # POST /application_keys.json
  def create
    @application_key = ApplicationKey.new(application_key_params)

    respond_to do |format|
      if @application_key.save
        format.html { redirect_to @application_key, notice: 'Application key was successfully created.' }
        format.json { render :show, status: :created, location: @application_key }
      else
        format.html { render :new }
        format.json { render json: @application_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /application_keys/1
  # PATCH/PUT /application_keys/1.json
  def update
    respond_to do |format|
      if @application_key.update(application_key_params)
        format.html { redirect_to @application_key, notice: 'Application key was successfully updated.' }
        format.json { render :show, status: :ok, location: @application_key }
      else
        format.html { render :edit }
        format.json { render json: @application_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /application_keys/1
  # DELETE /application_keys/1.json
  def destroy
    @application_key.destroy
    respond_to do |format|
      format.html { redirect_to application_keys_url, notice: 'Application key was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application_key
    @application_key = ApplicationKey.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def application_key_params
    params.require(:application_key).permit(:name)
  end
end
