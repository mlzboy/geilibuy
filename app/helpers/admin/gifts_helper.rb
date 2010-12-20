module Admin::GiftsHelper
  def sub_gift_path(gift)
    "/admin/gifts/#{gift.id}/sub"
  end
  
  def my_new_gift_path(parent)
    if parent!=nil
      "/admin/gifts/#{parent.id}/new"
    else
      "/admin/gifts/new"
    end
  end
end
