class UserMailer < ApplicationMailer
  default from: 'notifications@bugzilla.com'

  def login_notification(user, ip_address = nil)
    @user = user
    @ip_address = ip_address || "Unknown IP"
    @time = Time.current.strftime("%B %d, %Y at %I:%M %p")
    
    mail(to: @user.email, subject: "New sign-in to your Bugzilla account")
  end

  def sign_up(user, ip_address = nil)
    @user = user
    @ip_address = ip_address || "Unknown IP"
    @time = Time.current.strftime("%B %d, %Y at %I:%M %p")
    
    mail(to: @user.email, subject: "New sign-up")
  end
end