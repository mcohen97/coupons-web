class PromotionsController < ApplicationController
  protect_from_forgery except: :evaluate

  def index
    @promotions = Promotion.all.non_deleted
  end

  def show
    @promotion = Promotion.find(params[:id])
  end

  def new
  end

  def edit
    @promotion = Promotion.find(params[:id])
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
    @promotion.update(deleted: true)
    respond_to do |format|
      format.html { redirect_to promotions_path, notice: 'Promotion was successfully destroyed.' }
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

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def promotion_parameters
    params.require(:promotion).permit(:code, :name, :type, :return_type, :return_value, :active, :condition)
  end
end
