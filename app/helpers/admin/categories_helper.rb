module Admin::CategoriesHelper
  def sub_admin_category_path(category)
    "/admin/categories/#{category.id}/sub"
  end
  
  def my_new_admin_category_path(parent)
    if parent!=nil
      "/admin/categories/#{parent.id}/new"
    else
      "/admin/categories/new"
    end
  end
  
  def top?(parent)
    if parent.nil?
      return "top"
    else
      return parent.name
    end
  end
  
  def gen_parent
    if @parent.nil?
    elsif @parent.parent_id.blank?
      concat(raw "<a href='/admin/categories'>^|||</a>")
    else
      concat(raw "<a href='/admin/categories/"+@parent.parent_id.to_s+"/sub'>^|||</a>")
    end
  end
end
