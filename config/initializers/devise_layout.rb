# config/initializers/devise_layout.rb

# This block runs once on application startup (and after code reloads in development).
# It ensures that Devise controllers use your 'default' layout.
Rails.application.config.to_prepare do
  Devise::SessionsController.layout 'default'
  Devise::RegistrationsController.layout 'default'
  Devise::ConfirmationsController.layout 'default'
  Devise::PasswordsController.layout 'default'
  Devise::UnlocksController.layout 'default'
  # If you have a separate layout for Devise emails, you can set it here too:
  # Devise::Mailer.layout "mailer"
end
