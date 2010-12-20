ActionMailer::Base.add_delivery_method :active_record, ArMailerRails3::ActiveRecord, :email_class => Email
ActionMailer::Base.delivery_method = :active_record


config_file = "#{Rails.root}/config/smtp_gmail.yml"
raise "Sorry, you must have #{config_file}" unless File.exists?(config_file)

config_options = YAML.load_file(config_file) 
ActionMailer::Base.smtp_settings = {
  :address => "smtp.exmail.qq.com",
  :port => 25,
  :domain => 'qq.com',
  :authentication => :plain,
  :enable_starttls_auto => true
}.merge(config_options) # Configuration options override default options
#ActionMailer::Base.smtp_settings = {
#  :address => "smtp.126.com",
#  :port => 25,
#  :domain => '126.com',
#  :authentication => :plain,
#  :enable_starttls_auto => true
#}.merge(config_options) # Configuration options override default options