# frozen_string_literal: true

class ApplicationKeysController < ApplicationController
  before_action :set_application_key, only: %i[show edit update destroy]
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :application_key_not_found

  # GET /application_keys
  # GET /application_keys.json
  def index
    @application_keys = ApplicationKey.all
  end

  # GET /application_keys/1
  # GET /application_keys/1.json
  def show; end

  # GET /application_keys/new
  def new
    @application_key = ApplicationKey.new
    @form_title = 'New application key'
  end

  # GET /application_keys/1/edit
  def edit; 
    @form_title = 'Edit application key'
  end

  # POST /application_keys
  # POST /application_keys.json
  def create
    logger.info("Creating application key of params: #{application_key_params.inspect}.")
    @application_key = ApplicationKey.new(application_key_params)

    respond_to do |format|
      if @application_key.save
        logger.info("Application key was successfully created, with id: #{@application_key.id}.")
        format.html { redirect_to @application_key, notice: 'Application key was successfully created.' }
        format.json { render :show, status: :created, location: @application_key }
      else
        logger.error("Invalid application key with params: #{@application_key.errors.inspect}.")
        format.html { render :new }
        format.json { render json: @application_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /application_keys/1
  # PATCH/PUT /application_keys/1.json
  def update
    logger.info("Updating appkey of id: #{params[:id]}.")
    respond_to do |format|
      if @application_key.update(application_key_params)
        logger.info('Application key was successfully updated.')
        format.html { redirect_to @application_key, notice: 'Application key was successfully updated.' }
        format.json { render :show, status: :ok, location: @application_key }
      else
        logger.error("Invalid application key update, params: #{@application_key.errors.inspect}.")
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
      logger.info('Application key was successfully deleted.')
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
    params.require(:application_key).permit(:name, promotion_ids: [])
  end

  def application_key_not_found
    logger.error('Application key not found.')
  end
end
