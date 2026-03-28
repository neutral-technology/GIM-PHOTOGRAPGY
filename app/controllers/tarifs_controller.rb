class TarifsController < ApplicationController
  layout 'default'
  before_action :set_tarif, only: %i[edit update destroy show]
  before_action :set_tarif, only: %i[edit update destroy show]

  def index
    @tarifs = policy_scope(Tarif).order(:service)
  end

  def show
    authorize @tarif
  end

  def new
    @tarif = current_user.tarifs.new
    authorize @tarif
  end

  def edit
    authorize @tarif
  end

  def create
    @tarif = current_user.tarifs.new(tarif_params)
    authorize @tarif

    if @tarif.save
      redirect_to users_profile_path, notice: 'Tarif ajouté avec succès.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @tarif
    if @tarif.update(tarif_params)
      redirect_to tarifs_path, notice: 'Tarif mis à jour.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @tarif
    @tarif.destroy
    redirect_to tarifs_path, notice: 'Tarif supprimé.'
  end

  private

  def set_tarif
    @tarif = current_user.tarifs.find(params[:id])
  end

  def tarif_params
    params.require(:tarif).permit(
      :service,
      :price,
      :active,
      :currency,
      :note,
      :image
    )
  end
end
