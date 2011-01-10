#coding:utf-8
class CoreMail < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default :from => '"给力百货" <service@geilibuy.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.core_mail.product_arrival.subject
  #
  def registration_confirmation(user)  
    @user=user
    mail(:to => user.email, :subject => "[给力百货]注册邮箱验证")
  end  
  
  def consulting_reply(email)
    mail(:to => email, :subject => '[给力百货]客服回复邮件')

  end
  def coupon_send(email)
    mail(:to => email, :subject => '[给力百货]发红包')
  end
  def festival_promotion(email,title)
    mail(:to => email, :subject => "[给力百货]"+title)
  end
  def find_password(email)
    @user=User.find_by_email(email)
    mail(:to => email, :subject => '[给力百货]密码找回')
  end
  def order_confirm(email)
    mail(:to => email, :subject => '[给力百货]订单确认通知')
  end
  def order_send(order)
    @order=order
    mail(:to => order.user.email, :subject => '[给力百货]订单发货通知')
  end
  def product_arrival(email)
    mail(:to => email, :subject => '[给力百货]关注商品到货通知')
  end
  
  
end
