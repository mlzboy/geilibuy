#coding:utf-8
class ActiveMailer < ActionMailer::Base
  #default :from => "mlzboy@126.com"
  default :from => '"给力百货" <service@geilibuy.com>'

  def registration_confirmation(user)  
    @user=user
    mail(:to => user.email, :subject => "邮件验证")
    
  end  
end
