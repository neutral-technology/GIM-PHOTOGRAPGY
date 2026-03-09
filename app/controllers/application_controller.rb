class ApplicationController < ActionController::Base
  # Protect all actions by default (if you want all pages to require login)
  # before_action :authenticate_user! # Uncomment if you want all pages protected
  include Pundit::Authorization
  # Permit additional parameters for Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Lève une erreur si authorize ou policy_scope n'est pas appelé
  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "Vous n'avez pas les droits pour effectuer cette action."
    redirect_to(request.referrer || users_profile_path)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name city])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[full_name city])
  end

  def after_sign_out_path_for(_resource_or_scope)
    # Common options:
    new_user_session_path # Redirect to the login page (most common)
    # root_path             # Redirect to the application's home page
  end
end
