class ReturnController < ApplicationController
  def tuan_return_money
    user_id=params[:user_id]
    cookies["tuan_invite"]={
                              :value => user_id,
                              :expires => 3.days.from_now
                              :domain=>".geilibuy.com"
                            }
    redirect_to "/tuan/"
  end
end
