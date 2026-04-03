class PhotographersController < ApplicationController
  layout 'default'
  before_action :set_photographer, only: [:destroy]

  def index
    @photographers = policy_scope(Photographer).order(:name)
    @photographer = Photographer.new
    authorize Photographer
  end

  def create
    @photographer = Photographer.new(photographer_params)
    authorize @photographer

    if @photographer.save
      redirect_to photographers_path, notice: "Photographer created successfully"
    else
      @photographers = policy_scope(Photographer).order(:name)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @photographer
    @photographer.destroy
    redirect_to photographers_path, notice: "Photographer deleted"
  end

  private

  def set_photographer
    @photographer = Photographer.find(params[:id])
  end

  def photographer_params
    params.require(:photographer).permit(:name, :phone, :role, :active)
  end
end