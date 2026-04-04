class PhotographersController < ApplicationController
  layout 'default'
  before_action :set_photographer, only: [:destroy]

  def index
    @photographers = policy_scope(Photographer).order(:name)
    @photographer = Photographer.new
    authorize Photographer
    scoped = policy_scope(Receipt)

    # Today sessions
    @receipts = scoped
      .includes(:client, :photographer)
      .where(date: Time.zone.today)
      .order(:created_at)

    # Stats per photographer
    @stats = policy_scope(Receipt)
      .joins(:photographer)
      .where(date: Time.zone.today)
      .group('photographers.id', 'photographers.name')
      .select(
        "photographers.name AS photographer_name,
        COUNT(receipts.id) AS sessions_count,
        SUM(receipts.photos_count) AS total_photos"
      )
  end

  def create
    @photographer = Photographer.new(photographer_params)
    authorize @photographer

    if @photographer.save
      redirect_to photographers_path, notice: 'Photographer created successfully'
    else
      @photographers = policy_scope(Photographer).order(:name)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @photographer
    @photographer.destroy
    redirect_to photographers_path, notice: 'Photographer deleted'
  end

  private

  def set_photographer
    @photographer = Photographer.find(params[:id])
  end

  def photographer_params
    params.require(:photographer).permit(:name, :phone, :role, :active)
  end
end
