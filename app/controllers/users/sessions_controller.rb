# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  after_action :send_login_notification, only: :create

  private

  def send_login_notification
    if current_user
      UserMailer.login_notification(current_user, request.remote_ip).deliver_later
    end
  end
end
