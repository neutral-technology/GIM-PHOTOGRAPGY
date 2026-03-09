class UsersController < ApplicationController
  before_action :authenticate_user!
  # relying on @minimum_password_length
  before_action :set_devise_vars, only: [:users_account_settings]
  include Pundit::Authorization

  def update
    if current_user.update(user_params)
      redirect_to user_account_settings_path, notice: 'Profile mis à jour avec succès.'
    else
      render :user_account_settings, alert: 'Une erreur est survenue.'
    end
  end

  def users_profile
    @user = params[:id].present? ? User.find(params[:id]) : current_user
    authorize @user, :users_profile?
    # @user = current_user
    # authorize @user, :users_profile?

    # dashboard data
    load_dashboard_data

    # filters
    load_filters

    # Totals
    load_totals

    @vip_clients = current_user.clients
      .vip_for(@user)
    # .order(vip_reached_at: :desc)

    if @user
      render layout: 'default', template: 'users/profile'
    else
      redirect_to new_user_session_path, alert: 'Please sign in first.'
    end
  end

  def users_account_settings
    @user = current_user
    render layout: 'default', template: 'users/user-account-settings'
  end

  def update_profile
    @user = User.find(params[:id]) rescue current_user
    authorize @user # This triggers UserPolicy#update_profile?

    if @user.update(user_params)
      redirect_to users_profile_path(@user), notice: 'Profile mis à jour avec succès.'
    else
      render 'user-account-settings', status: :unprocessable_entity
    end
  end

  def load_filters
    # Filters
    case params[:filter]
    when 'week'
      @receipts = @receipts.where(date: Date.current.all_week)
    when 'month'
      @receipts = @receipts.where(date: Date.current.all_month)
    end

    if params[:day].present?
      day = begin
        Date.parse(params[:day])
      rescue StandardError
        nil
      end
      @receipts = @receipts.where(date: day) if day
    end

    return if params[:month].blank?

    year = params[:year].present? ? params[:year].to_i : Date.current.year
    month = params[:month].to_i
    from = Date.new(year, month, 1)
    to = from.end_of_month
    @receipts = @receipts.where(date: from..to)
  end

  def report_range
    month = params[:month].presence&.to_i || Date.current.month
    year = params[:year].presence&.to_i || Date.current.year

    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    start_date..end_date
  end

  private

  def load_totals
    # REPORT (filtered)
    range = report_range
    @report_expenses = current_user.expenses.where(expense_date: range)
    @report_receipts = current_user.receipts.where(date: range)

    @total_income_usd = @report_receipts.where(currency: :usd).sum(:amount)
    @total_income_fr = @report_receipts.where(currency: :cdf).sum(:amount)

    @total_expense_usd = @report_expenses.spent.usd.sum(:amount)
    @total_expense_fr = @report_expenses.spent.cdf.sum(:amount)

    @total_refund_usd = @report_expenses.refunded.usd.sum(:amount)
    @total_refund_cdf = @report_expenses.refunded.cdf.sum(:amount)

    @net_result_usd = @total_income_usd - @total_expense_usd + @total_refund_usd
    @net_result_cdf = @total_income_fr - @total_expense_fr + @total_refund_cdf
  end

  def load_dashboard_data
    @albums = @user.albums.order(created_at: :desc) # .includes(:client).order(created_at: :desc)
    @receipts = @user.receipts.order(date: :desc)
    @tarifs = @user.tarifs.order(created_at: :desc)
    @expenses = @user.expenses.order(created_at: :desc)
    @clients = @user.clients.order(created_at: :desc)
    
    @brochures = policy_scope(Brochure)
                   .includes(:brochure_preset)
                   .order(created_at: :desc)
    @brochure_presets = BrochurePreset.all
    @new_brochure = current_user.brochures.new
  end

  def set_devise_vars
    @resource = current_user
    @resource_name = :user
    @devise_mapping = Devise.mappings[:user]
  end

  def user_params
    params.require(:user).permit(:full_name, :sex, :city, :vip_threshold)
  end
end
