class UsersController < ApplicationController
  before_action :authenticate_user!
  # relying on @minimum_password_length
  before_action :set_devise_vars, only: [:users_account_settings]

  def update
    if current_user.update(user_params)
      redirect_to user_account_settings_path, notice: 'Profile mis à jour avec succès.'
    else
      render :user_account_settings, alert: 'Une erreur est survenue.'
    end
  end

  def users_profile
    @user = current_user
    @albums = Album.all # .includes(:client).order(created_at: :desc)
    @receipts = current_user.receipts.order(date: :desc)
    @total_income = @receipts.sum(:amount)
    @total_transactions = @receipts.count
    @tarifs = current_user.tarifs
    filters
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
    if current_user.update(user_params)
      redirect_to users_profile_path, notice: 'Profile mis à jour avec succès.'
    else
      render 'user-account-settings', status: :unprocessable_entity
    end
  end

  def filters
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

  private

  def set_devise_vars
    @resource = current_user
    @resource_name = :user
    @devise_mapping = Devise.mappings[:user]
  end

  def user_params
    params.require(:user).permit(:full_name, :sex, :city)
  end
end
