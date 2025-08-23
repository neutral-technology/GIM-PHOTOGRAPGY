class ApplicationController < ActionController::Base
  # Protect all actions by default (if you want all pages to require login)
  # before_action :authenticate_user! # Uncomment if you want all pages protected

  # Permit additional parameters for Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name is_pastor is_message_believer city])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[full_name is_pastor is_message_believer city])
  end

  def after_sign_out_path_for(_resource_or_scope)
    # Common options:
    new_user_session_path # Redirect to the login page (most common)
    # root_path             # Redirect to the application's home page
  end
end
