# frozen_string_literal: true

class PromotionsController < ApplicationController
  protect_from_forgery except: :evaluate
  prepend_before_action :authenticate!
  #before_action :authorize_user!, only: %i[new create edit update destroy]
  before_action :set_promo, only: %i[show edit]

  def index
    filters = {}
    filters[:code] = params[:code] if params[:code].present?
    filters[:name] = params[:name] if params[:name].present?
    filters[:type] = params[:type] if params[:type].present?
    filters[:active] = params[:active] if params[:active].present?

    
    @promotions = PromotionsService.instance.get_promotions(filters)
  end

  def show
    if @promotion.type == 'Coupon'
      @coupon_instances = CouponInstance.where(promotion_id: @promotion.id)
    end
  end

  def new
    @promotion = Promotion.new
    @form_title = 'New promotion'
  end

  def edit
    @form_title = 'Edit promotion'
    @is_edit = true
  end

  def create
    puts "PARAMETERS #{promotion_parameters.inspect}"
    @promotion = Promotion.new(promotion_parameters)
    is_coupon = @promotion.type == 'coupon'
    if is_coupon && !valid_instances_count
      @promotion.errors.add(:coupon_instances, "Coupon count must be positive and less or equal to #{Coupon::MAX_COUPON_INSTANCES}")
      respond_promotion_not_created(@promotion) && return
    end

    result = PromotionsService.instance.create_promotion(promotion_parameters)
    if result.success
      logger.info("Successfully updated promotion of id: #{@promotion.id}.")
      respond_promotion_created(@promotion) && return
    else
      @promotion.errors.add(:error, result.data.to_s)
      respond_promotion_not_created(@promotion)
    end
  end

  def update
    respond_to do |format|
      result = PromotionsService.instance.update_promotion(params[:promotion][:id],promotion_parameters)
      if result.success
        @promotion = result.data
        logger.info("Successfully updated promotion of id: #{@promotion.id}.")
        format.html { redirect_to @promotion, notice: 'Promotion was updated successfully.' }
        format.json { render :show, status: :ok, location: @promotion }
      else
        @promotion.errors.add(:error, result.data.to_s)

        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    result = PromotionsService.instance.delete_promotion(params[:id])
    respond_to do |format|
      logger.info("Successfully deleted promotion of id: #{params[:id]}.")
      format.html { redirect_to promotions_path, notice: 'Promotion was successfully deleted.' }
      format.json { render json: { notice: 'Promotion was successfully deleted.' }, status: :success }
    end
  end

  def evaluate
    response =Services.promotions_service.evaluate(params[:code],params[:attributes])
    render json: response, status: :success
  end
  

  def report
    promotion_id = params[:id]

    @promotion = PromotionsService.instance.get_promotion_by_id(promotion_id)

    demographic_response = ReportsService.instance.get_demographic_report(promotion_id)
    if demographic_response.success
      @demographic_report = demographic_response.data
    else
      flash[:error] = demographic_response.data
    end
    
    usage_response = ReportsService.instance.get_usage_report(promotion_id)
    if usage_response.success
      @usage_report = usage_response.data
    else
      flash[:error] = usage_response.data
    end

    respond_to do |format|
      format.html { :report }
    end

  end

  private

  def valid_instances_count
    coupon_instances_count < Coupon::MAX_COUPON_INSTANCES
  end

  def respond_promotion_created(promotion)
    respond_to do |format|
      format.html { redirect_to promotions_path, notice: 'Promotion was successfully created.' }
      format.json { render :show, status: :created, location: promotion }
    end
  end

  def respond_promotion_not_created(promotion)
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: promotion.errors, status: :unprocessable_entity }
    end
  end

  def generate_coupon_instances(promotion)
    puts instance_expiration_date
    promotion.generate_coupon_instances(coupon_instances_count, instance_expiration_date)
  end

  def evaluate_existing_promotion(promotion, appkey)
    result = promotion.evaluate_applicability(params[:attributes], appkey)
    render json: result
  rescue NotAuthenticatedError => e
    logger.error('No valid application key.')
    render(json: { error_message: e.message }, status: :unauthorized)
  rescue NotAuthorizedError => e
    logger.error('User not authorized')
    render json: { error_message: e.message }, status: :forbidden
  rescue PromotionArgumentsError => e
    logger.error('Invalid promotion arguments')
    render json: { error_message: e.message }, status: :bad_request
  end

  def set_promo
    #@promotion = Promotion.find(params[:id])
    puts "PROMOTION ID #{params[:id]}"
    @promotion = PromotionsService.instance.get_promotion_by_id(params[:id])
    #promotion_not_found if @promotion.deleted
    #@promotion = @promotion.becomes(Promotion)
  end

  def promotion_not_found
    respond_to do |format|
      logger.error('Promotion not found.')
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.json { render json: { error: 'Promotion not found.' }.to_json, status: :not_found }
    end
  end

  def set_pagination(collection)
    offset = pagination_offset
    per_page = pagination_per_page
    collection.paginate(page: offset, per_page: per_page)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def promotion_parameters
    p = params.require(:promotion).permit(:name,:code ,:type, :condition,:return_type, :return_value, :active, :expiration, :promotion_type).to_h
    p[:return_value] = p[:return_value].to_i
    p[:active] = p[:active] == "true"
    return p
  end

  def coupon_instances_count
    params.fetch(:instances_count, Coupon::DEFAULT_COUPON_INSTANCES).to_i
  end

  def instance_expiration_date
    params.fetch(:instance_expiration_date, @promotion.expiration_date)
  end

  def pagination_offset
    params[:page].present? ? params[:page] : 1
  end

  def pagination_per_page
    params[:per_page].present? ? params[:per_page] : 6
  end
end
