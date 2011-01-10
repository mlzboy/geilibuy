#coding:utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  #helper :all
  def current_user
    User.find_by_email(session["user"]["email"])
  end
  def has_login?
    if session.key?("user")
      true
    else
      false
    end
  end
  def login?
    if !session.key?("user")
      logger.debug("不存在")
      redirect_to "/usercenter/login?back_url=#{request.request_uri}"
    end
  end
  
  def tuan_login?
    logger.debug("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY")
    unless has_login?
      redirect_to "/tuan/account/login?back_url=#{request.fullpath}"
      #render :js=>"window.location.href='/tuan/account/login?back_url=#{request.fullpath}'"
      return
    end
  end
  
  def admin_login?
    if has_login? and current_user.kind>0
      logger.debug("admin login-------------")
    else
      logger.debug("didn't  admin login ---------------------")
      unless request.request_uri.count("logout")>0
        redirect_to "/usercenter/login?back_url=#{request.request_uri}"
      else
        redirect_to "/usercenter/login"
      end
      return
    end
  end
end
