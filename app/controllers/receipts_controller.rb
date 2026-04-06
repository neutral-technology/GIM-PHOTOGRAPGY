class ReceiptsController < ApplicationController
  layout 'default'
  before_action :authenticate_user!
  before_action :set_receipt, only: %i[show edit update destroy]

  def index
    @receipts = policy_scope(Receipt).order(created_at: :asc)
  end

  def show
    authorize @receipt
  end

  def new
    @receipt = current_user.receipts.new(currency: :cdf, paid_currency: :cdf)
    authorize @receipt
    @clients = current_user.clients.order(created_at: :desc).includes(:album) # you can filter later if needed
    @photographers = Photographer.where(active: true)
    @clients_json = @clients.select(:id, :name, :tel).to_json
  end

  def edit
    authorize @receipt
  end

  def create
    @receipt = current_user.receipts.new(receipt_params)
    authorize @receipt

    # Automatically assign the album of the selected client
    client = current_user.clients.find_by(id: @receipt.client_id)
    if client.album.present?
      @receipt.album = client.album
    else
      generated_password = SecureRandom.random_number(10**6).to_s.rjust(6, '0')

      album = client.create_album!(
        user: current_user,
        password: generated_password,
        access_code: generated_password
      )

      @receipt.album = album
    end

    @photographers = Photographer.where(active: true)

    if @receipt.save
      redirect_to users_profile_path, notice: 'Reçu créé avec succès'
    else
      Rails.logger.debug "Receipt Validation Failed: #{@receipt.errors.full_messages}"
      # Reload variables needed for the 'new' view
    @clients = current_user.clients.order(created_at: :desc)
    @photographers = Photographer.where(active: true)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @receipt

    if @receipt.update(receipt_params)
      redirect_to @receipt, notice: 'Reçu mis à jour'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @receipt
    @receipt.destroy
    redirect_to receipts_path, notice: 'Reçu supprimé'
  end

  private

  def set_receipt
    @receipt = current_user.receipts.find(params[:id])
  end

  def receipt_params
    params.require(:receipt).permit(:shooting_type, :photos_count, :amount, :amount_paid, :date, :currency, :paid_currency, :exchange_rate,
                                    :client_id, :album_id, :photographer_id, :created_by_id)
  end
end
