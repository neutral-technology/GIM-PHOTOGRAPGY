class ExpensesController < ApplicationController
  layout 'default'
  before_action :authenticate_user!
  before_action :set_expense, only: %i[refund cancel]

  def index
    @expenses = current_user.expenses.order(expense_date: :desc)
  end

  def new
    @expense = current_user.expenses.new
  end

  def create
    @expense = current_user.expenses.new(expense_params)

    if @expense.save
      redirect_to users_profile_path, notice: 'Dépense ajoutée avec succès'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def refund
    @expense.refunded!
    redirect_to users_profile_path, notice: 'Dépense remboursée'
  end

  def cancel
    @expense.canceled!
    redirect_to users_profile_path, alert: 'Dépense annulée'
  end

  private

  def set_expense
    @expense = current_user.expenses.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(
      :amount,
      :currency,
      :category,
      :note,
      :expense_date
    )
  end
end
