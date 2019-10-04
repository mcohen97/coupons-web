# frozen_string_literal: true

class PromotionsController < ApplicationController
  protect_from_forgery except: :evaluate
  before_action :authenticate_user!, except: %i[evaluate report]
  before_action :set_promo, only: %i[show edit update destroy report]
  rescue_from ActiveRecord::RecordNotFound, with: :promotion_not_found

  def index
    @promotions = Promotion.not_deleted
    @promotions = @promotions.by_code(params[:code]) if params[:code].present?
    @promotions = @promotions.by_name(params[:name]) if params[:name].present?
    @promotions = @promotions.by_type(params[:type]) if params[:type].present?
    @promotions = @promotions.active?(params[:active]) if params[:active].present?
    @promotions = set_pagination(@promotions)
  end

  def show;
    if @promotion.type == 'Coupon'
      @coupon_instances = CouponInstance.where(promotion_id: @promotion.id)
    end 
  end

  def new
    @promotion = Promotion.new
    @form_title = "New promotion"
  end

  def edit
    @form_title = "Edit promotion"
  end

  def create
    @promotion = Promotion.new(promotion_parameters)

    respond_to do |format|
      if @promotion.save
        format.html { redirect_to promotions_path, notice: 'Promotion was successfully created.'}
        logger.info("Successfully created promotion of id: #{@promotion.id}")
        format.json { render :show, status: :created, location: @promotion }
        if @promotion.type == 'Coupon'
          generate_coupon_instances(@promotion)
        end
      else
        format.html { render :new }
        format.json { render json: @promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @promotion.update(promotion_parameters)
        logger.info("Successfully updated promotion of id: #{@promotion.id}.")
        format.html { redirect_to @promotion, notice: 'Promotion was updated successfully.' }
        format.json { render :show, status: :ok, location: @promotion }
      else
        format.html { render :edit }
        format.json { render json: @promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @promotion.update(deleted: true)
    respond_to do |format|
      logger.info("Successfully deleted promotion of id: #{@promotion.id}.")
      format.html { redirect_to promotions_path, notice: 'Promotion was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def evaluate
    logger.info("Evaluating promotion #{params[:code]}.")
    appkey = get_app_key
    if appkey.nil?
      logger.error('No valid application key.')
      render(json: { error_message: 'No valid application key.' }, status: :unauthorized) && return
    end
    promotion = Promotion.find_by(code: params[:code])
    if !promotion.nil?
      logger.info("Successfully evaluated promotion of code: #{params[:code]}")
      evaluate_existing_promotion(promotion, appkey)
    else
      logger.error('Promotion not found')
      render json: { error_message: 'Promotion not found' }, status: :not_found
    end
  end

  def report
    if is_backoffice_client
      respond_to_backoffice
    else
      respond_to_external
    end
  end

  private

  def generate_coupon_instances(promotion)
    promotion.generate_coupon_instances(coupon_instances_count)
  end

  def evaluate_existing_promotion(promotion, appkey)
    result = promotion.evaluate_applicability(params[:attributes], appkey)
    render json: result
  rescue NotAuthorizedError => e
    logger.error('User not authorized')
    render json: { error_message: e.message }, status: :forbidden
  rescue PromotionArgumentsError => e
    logger.error('Invalid promotion arguments')
    render json: { error_message: e.message }, status: :bad_request
  end

  def is_backoffice_client
    !request.headers['Content-Type'].present? || request.headers['Content-Type'] == 'text/html'
  end

  def respond_to_backoffice
    authenticate_user!
    @report = @promotion.generate_report
  end

  def respond_to_external
    appkey = get_app_key
    if appkey.nil?
      logger.error('No valid application key.')
      render(json: { error_message: 'No valid application key.' }, status: :unauthorized) && return
    end
    if appkey.organization_id != @promotion.organization_id
      logger.error('User not authorized.')
      render(json: { error_message: 'Cant get report from other organization promotions.' }, status: :forbidden) && return
    end
    @report = @promotion.generate_report
    render json: @report, status: :ok
  end

  def set_promo
    @promotion = Promotion.find(params[:id])
    @promotion = @promotion.becomes(Promotion)
  end

  def promotion_not_found
    respond_to do |format|
      logger.error('Promotion not found.')
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.json { render json: { error: 'Promotion not found.' }.to_json, status: :not_found }
    end
  end

  def get_app_key
    token = request.headers['Authorization']
    ApplicationKey.get_from_token_if_valid(token)
  end

  def set_pagination(collection)
    offset = pagination_offset
    per_page = pagination_per_page
    collection.paginate(page: offset, per_page: per_page)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def promotion_parameters
    params.require(:promotion).permit(:code, :name, :type, :return_type, :return_value, :active, :condition)
  end

  def coupon_instances_count
    params.fetch(:instances_count, 5)
  end

  def pagination_offset
    params[:page].present? ? params[:page] : 1
  end

  def pagination_per_page
    params[:per_page].present? ? params[:per_page] : 5
  end
end
