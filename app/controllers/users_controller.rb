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

  private

  def set_devise_vars
    @resource = current_user
    @resource_name = :user
    @devise_mapping = Devise.mappings[:user]
  end

  def user_params
    params.require(:user).permit(:full_name, :is_message_believer, :is_pastor, :sex, :city)
  end
end
