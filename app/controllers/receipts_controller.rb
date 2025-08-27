class ReceiptsController < ApplicationController
  layout 'default'
  before_action :authenticate_user!
  before_action :set_receipt, only: %i[ show edit update destroy ]

  def index
    @receipts = current_user.receipts.order(date: :desc)
  end

  def new
    @receipt = current_user.receipts.new
  end

  def create
    @receipt = current_user.receipts.new(receipt_params)
    if @receipt.save
      redirect_to users_profile_path, notice: "okay."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def set_receipt
      @receipt = current_user.receipts.find(params[:id])
    end

    def receipt_params
      params.require(:receipt).permit(:shooting_type, :photos_count, :amount, :date, :notes)
    end
end
