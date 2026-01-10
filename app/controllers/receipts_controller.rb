class ReceiptsController < ApplicationController
  layout 'default'
  before_action :authenticate_user!
  before_action :set_receipt, only: %i[show edit update destroy]

  def index
    @receipts = current_user.receipts.order(created_at: :asc)
  end

  def new
    @receipt = current_user.receipts.new
    @clients = current_user.clients.order(created_at: :desc).includes(:album) # you can filter later if needed
  end

  def create
    @receipt = current_user.receipts.new(receipt_params)

    # Automatically assign the album of the selected client
    client = current_user.clients.find_by(id: @receipt.client_id)
    @receipt.album = client.album if client

    if @receipt.save
      redirect_to users_profile_path, notice: 'Reçu créé avec succès'
    else
      @clients = current_user.clients
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_receipt
    @receipt = current_user.receipts.find(params[:id])
  end

  def receipt_params
    params.require(:receipt).permit(:shooting_type, :photos_count, :amount, :amount_paid, :date, :currency, :paid_currency, :exchange_rate,
                                    :client_id)
  end
end
