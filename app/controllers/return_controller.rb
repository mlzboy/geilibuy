class ReturnController < ApplicationController
  def tuan_return_money
    user_id=params[:user_id]
    cookies["tuan_invite"]={
                              :value => user_id,
                              :expires => 3.days.from_now,
                              :domain => ".geilibuy.com"
                            }
    redirect_to "/tuan/"
  end
  #从外部导入的链接，记推荐人的id3天，3天之内该用户登录都算他的推荐
  def lottery_return_scores
    logger.debug params["user_id"]
    user_id=params[:user_id]
    cookies["lottery_invite"]={
                              :value => user_id,
                              :expires => 3.days.from_now,
                              :domain => ".geilibuy.com"
                            }
    redirect_to "/lottery"
  end
end
