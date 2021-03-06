# frozen_string_literal: true

class ApplicationKeysController < ApplicationController
  #prepend_before_action :authenticate_user!
  before_action :authenticate!
  before_action :set_application_key, only: %i[show edit]

  def index
    @application_keys = ApplicationKeysService.instance.get_application_keys(page = nil, offset = nil)
  end

  def show;
  end

  def new
    @application_key = ApplicationKey.new
    @form_title = 'New application key'
    @promotions = PromotionsService.instance.get_promotions
  end

  def edit
    @promotions = PromotionsService.instance.get_promotions
    @in_appkey = Set.new(@application_key.promotions.map(&:id))
    @application_key.new = false
    @form_title = 'Edit application key'
  end

  # POST /application_keys
  # POST /application_keys.json
  def create
    logger.info("Creating application key of params: #{application_key_params.inspect}.")
    result = ApplicationKeysService.instance.create_application_key(application_key_params)
    if result.success
      @application_key = result.data
      logger.info("Application key was successfully created, with id: #{@application_key.token}.")
      redirect_to @application_key, notice: 'Application key was successfully created.'
    else
      @application_key = ApplicationKey.new(application_key_params)
      logger.error("Invalid application key with params: #{result.data.inspect}.")
      @application_key.errors.add(:error, result.data['error'].to_s)
      flash[:error] = @application_key.errors.full_messages
      redirect_to new_application_key_path(@application_key.token)
    end
  end

  def update
    logger.info("Updating appkey of id: #{params[:id]}.")
    result = ApplicationKeysService.instance.update_application_key(params[:id], application_key_params)
    @application_key = ApplicationKey.new(application_key_params)
    if result.success
      logger.info('Application key was successfully updated.')
      redirect_to @application_key, notice: 'Application key was successfully updated.'
    else
      @application_key.errors.add(:error, result.data['error'].to_s)
      logger.error("Invalid application key update, params: #{result.data.inspect}.")
      render :edit, status: :unprocessable_entity
    end

  end

  def destroy
    result = ApplicationKeysService.instance.delete_application_key(params[:id])
    respond_to do |format|
      logger.info('Application key was successfully deleted.')
      format.html { redirect_to application_keys_url, notice: 'Application key was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application_key
    @application_key = ApplicationKeysService.instance.get_application_key(params[:id])
    @application_key.new = false
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def application_key_params
    puts params
    params.require(:application_key).permit(:name, promotions: [])
  end

  def application_key_not_found
    respond_to do |format|
      logger.error('Application key not found.')
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.json { render json: {error: 'Promotion not found.'}.to_json, status: :not_found }
    end
  end

  def set_pagination(collection)
    offset = pagination_offset
    per_page = pagination_per_page
    collection.paginate(page: offset, per_page: per_page)
  end

  def pagination_offset
    params[:page].present? ? params[:page] : 1
  end

  def pagination_per_page
    params[:per_page].present? ? params[:per_page] : 10
  end
end
