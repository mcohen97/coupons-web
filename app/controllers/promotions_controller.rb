class PromotionsController < ApplicationController
  protect_from_forgery except: :evaluate
  before_action :authenticate_user!, except: [:evaluate, :report]

  def index
    @promotions = Promotion.not_deleted
    @promotions = @promotions.by_code(params[:code]) if params[:code].present?
    @promotions = @promotions.by_name(params[:name]) if params[:name].present?
    @promotions = @promotions.by_type(params[:type]) if params[:type].present?
    @promotions = @promotions.active?(params[:active]) if params[:active].present?
    @promotions = set_pagination(@promotions)
  end

  def show
    @promotion = Promotion.find_by(id: params[:id])
    send_error_if_nil(@promotion)
  end

  def new
    @promotion = Promotion.new
  end

  def edit
    @promotion = Promotion.find_by(id: params[:id])
    send_error_if_nil(@promotion)
  end

  def create
    @promotion = Promotion.new(promotion_parameters)

    respond_to do |format|
      if @promotion.save
        format.html { redirect_to promotion_path(@promotion), notice: 'Promotion was successfully created.'}
        format.json { render :show, status: :created, location: @promotion }
      else
        format.html { render @promotion.errors }
        format.json { render json: @promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @promotion = Promotion.find(params[:id])
    @promotion.update(promotion_parameters)
    redirect_to promotion_path(@promotion)
  end

  def destroy
    @promotion = Promotion.find(params[:id])
    send_error_if_nil(@promotion)
    @promotion.update(deleted: true)
    respond_to do |format|
      format.html { redirect_to promotions_path, notice: 'Promotion was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def evaluate
    promotion = Promotion.find_by(code: params[:code])
    if !promotion.nil?
      render json: promotion.evaluate_applicability(params[:attributes])
    else
      render json: {error: true, message: 'Promotion not found'}
    end
  end

  def report
    @promotion = Promotion.find(params[:id])
    @report = @promotion.generate_report()
  end

  private

  def send_error_if_nil(promotion)
    if promotion.nil?
      @promotions = Promotion.not_deleted
      @promotions = set_pagination(@promotions)
      logger.error{"The promotion was not found"}
      flash[:alert] = "The promotion was not found"
      render "index"
    end
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
