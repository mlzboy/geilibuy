#coding:utf-8
class TuanMail < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  #default :from => "mlzboy@126.com"
  default :from => '"给力团" <tuan@geilibuy.com>'


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tuan_mail.everyday.subject
  #
  def everyday(tuan,email,user=nil,title=nil)
    @tuan=tuan
    @user=user
    if title.nil?
      title=@tuan.sub_title
    end
    #@tuan=Tuan.today
    #@user=User.last
    #mail :to => "to@example.org"
    mail(:to => email, :subject => title,:from=>'"给力团 给力百货" <service@geilibuy.com>')
    #render 'dd'
  end
  
  def order_confirm(order,email,title)
    @order=order
    mail(:to => email, :subject => "[给力团]您在给力团的订单已确认")
  end
  
  def order_send(order,email=nil,title=nil)
    @order=order
    email=order.user.email if email.nil?
    title="[给力团]订单发货通知" if title.nil?
    mail(:to =>email, :subject => title)
  end
end
