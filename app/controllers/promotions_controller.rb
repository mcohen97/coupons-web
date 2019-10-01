class PromotionsController < ApplicationController
  protect_from_forgery except: :evaluate
  before_action :authenticate_user!, except: [:evaluate, :report]
  before_action :set_promo, only: [:show, :edit, :update, :destroy, :report]
  rescue_from ActiveRecord::RecordNotFound, :with => :promotion_not_found



  def index
    @promotions = Promotion.not_deleted
    @promotions = @promotions.by_code(params[:code]) if params[:code].present?
    @promotions = @promotions.by_name(params[:name]) if params[:name].present?
    @promotions = @promotions.by_type(params[:type]) if params[:type].present?
    @promotions = @promotions.active?(params[:active]) if params[:active].present?
    @promotions = set_pagination(@promotions)
  end

  def show
  end

  def new
    @promotion = Promotion.new
  end

  def edit
  end

  def create
    @promotion = Promotion.new(promotion_parameters)

    respond_to do |format|
      if @promotion.save
        format.html { redirect_to promotion_path(@promotion), notice: 'Promotion was successfully created.'}
        format.json { render :show, status: :created, location: @promotion }
      else
        format.html { render :new}
        format.json { render json: @promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @promotion.update(promotion_parameters)
        format.html { redirect_to @promotion, notice: 'La promocion fue modificada exitosamente.' }
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
      format.html { redirect_to promotions_path, notice: 'Promotion was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def evaluate
    appkey = get_app_key()
    if appkey.nil?
      render json: {message: 'No valid application key'} , status: :unauthorized and return 
    end
    promotion = Promotion.find_by(code: params[:code])
    if !promotion.nil?
      evaluate_existing_promotion(promotion, appkey)
    else
      render json: {error: true, message: 'Promotion not found'}
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

  def evaluate_existing_promotion(promotion, appkey)
    begin
      result = promotion.evaluate_applicability(params[:attributes], appkey)
      render json: result
    rescue NotAuthorizedError => e
      render json: {message: e.message}, status: :forbidden
    rescue PromotionArgumentsError => e
      render json: {message: e.message}, status: :bad_request
    end
  end

  def is_backoffice_client
    return ! request.headers['Content-Type'].present? ||  request.headers['Content-Type'] == 'text/html'
  end

  def respond_to_backoffice
    authenticate_user!
    @report = @promotion.generate_report()
  end

  def respond_to_external
    appkey = get_app_key()
    if appkey.nil?
      render json: {message: 'No valid application key'} , status: 401 and return 
    end
    @report = @promotion.generate_report()
    render json: @report, status: :ok
  end
  
  def set_promo
    @promotion = Promotion.find(params[:id])
    @promotion = @promotion.becomes(Promotion)
  end

  def promotion_not_found
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.json{render json: {error: 'Promotion not found'}.to_json, status: :not_found}
    end
  end 

  def get_app_key
    token  = request.headers["Authorization"]
    return ApplicationKey.get_from_token_if_valid(token)
  end

  def set_pagination(collection)
    offset = pagination_offset
    per_page = pagination_per_page
    return collection.paginate(page: offset, per_page: per_page)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def promotion_parameters
    params.require(:promotion).permit(:code, :name, :type, :return_type, :return_value, :active, :condition)
  end

  def pagination_offset
    return params[:page].present? ? params[:page] : 1
  end

  def pagination_per_page
    return params[:per_page].present? ? params[:per_page] : 5
  end

end
