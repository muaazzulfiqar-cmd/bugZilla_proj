# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]

  after_action :send_welcome_email, only: [ :create ], if: :resource_persisted?

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :selected_global_role, :role_password ])
  end

  private

  def send_welcome_email
    if resource.persisted?
      UserMailer.sign_up(resource, request.remote_ip).deliver_later
    end
  end

  def resource_persisted?
    resource.persisted?
  end
end
