#coding:utf-8
class Admin::BrandsController < AdminController
  layout "admin"
  def batch_select
    @product=Product.new
    if request.get?
      @products=Product.name_like("%枕%").on_equals(true)
    else
      act=params[:act]
      @product=Product.new(params[:product])
      @products=Product.name_like(@product.name).on_equals(true)
      logger.debug("FFFFFFFFFFff")
      logger.debug(@product.name)
      
      if act=="save"
        product_ids=params["product_id"]
        brand_id=params["brand_id"]
        logger.debug product_ids
        logger.debug brand_id
        if product_ids.nil? or product_ids.blank?
          product_ids=[]
        end
        if product_ids.size==0 or brand_id.blank?
        else
          Product.find(product_ids).each do |product|
            product.brand_id=brand_id
            product.save false
          end
          flash[:info]="保存成功"
        end
      elsif act=="query"
          flash[:info]="查询成功"
      end
    end
    #render :layout=>"test"
  end
  # GET /admin/brands
  # GET /admin/brands.xml
  def index
    @brands = Brand.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @brands }
    end
  end

  # GET /admin/brands/1
  # GET /admin/brands/1.xml
  def show
    @brand = Brand.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @brand }
    end
  end

  # GET /admin/brands/new
  # GET /admin/brands/new.xml
  def new
    @brand = Brand.new
    @categories = Category.top
    logger.debug("===================")
    logger.debug(@categories.size)
    logger.debug(@categories)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @brand }
    end
  end
  
  #品牌预选择ids集，for product edit page
  def ajax_ids
    q=[]
    coll=Brand.find(params[:id]).categories
    if coll.size>0
      q<<params[:id]
      q<<coll.first.id.to_s
    end
    q=q.reverse
    render :json=>q
  end
  
  #在两级菜单中显示产品品牌，一级为顶级Category分类，二级为brand
  #给一个catgory_id找出其下的所属品牌
  def ajax_get_brands_by_category_id
    @h={}
    if params[:id].blank?
      coll=Category.find_by_sql("select * from categories where id in (select distinct category_id from brands_categories)")
    else
      coll=Category.find(params[:id]).brands
    end
    for e in coll
      @h[e.id]=e.name
    end
    respond_to do |format|
      format.js {render :json =>@h}
    end
  end
  # GET /admin/brands/1/edit
  def edit
    @categories = Category.top
    @brand = Brand.find(params[:id])
  end

  # POST /admin/brands
  # POST /admin/brands.xml
  def create
    @brand = Brand.new(params[:brand])
    category_ids=params[:category_id] || []
    logger.debug("-------------------------------")
    logger.debug(category_ids)
    respond_to do |format|
      if @brand.save
        @brand.categories=Category.find_all_by_id(category_ids)
        format.html { redirect_to([:admin,@brand], :notice => 'Brand was successfully created.') }
        format.xml  { render :xml => @brand, :status => :created, :location => @brand }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @brand.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/brands/1
  # PUT /admin/brands/1.xml
  def update
    @brand = Brand.find(params[:id])
    category_ids=params[:category_id] || []
    respond_to do |format|
      if @brand.update_attributes(params[:brand])
        @brand.categories=Category.find_all_by_id(category_ids)
        format.html { redirect_to([:admin,@brand], :notice => 'Brand was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @brand.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/brands/1
  # DELETE /admin/brands/1.xml
  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy

    respond_to do |format|
      format.html { redirect_to(admin_brands_url) }
      format.xml  { head :ok }
    end
  end
end
