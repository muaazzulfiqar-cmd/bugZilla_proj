# config/environments/development.rb
Rails.application.configure do
  # Add this line at the top with other configs
  config.eager_load = false
  
  # ... other settings at the top ...

  # Add this line
  config.active_storage.service = :local

  # Use SMTP for email delivery (remove letter_opener line)
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    domain: 'localhost:3000',
    user_name: 'muaaz.zulfiqar@stackpinnacle.com',
    password: 'funr aavq kwhx yikt ',
    authentication: 'plain',
    enable_starttls_auto: true
  }
  
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.raise_delivery_errors = true
end