#coding:utf-8
class Admin::ProductsController < AdminController
  layout "test"

  def index
    category_ids=params[:category_id]
    if category_ids.nil?
      category_ids=[]
    end
    stock=params[:stock]
    score=params[:score]
    keyword=params[:keyword]
    promotion=params[:promotion]
    on=params[:on]
    new=params[:new]
    logger.debug("-=====================")
    logger.debug(category_ids)
    logger.debug(stock)
    logger.debug(score)
    logger.debug(promotion)
    logger.debug(keyword)
    logger.debug(on)
    logger.debug(new)

    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    if !params[:source].blank?#当为query按钮提交的查询时，
      page=1
    end

    all_ids=[]
    category_ids=category_ids.uniq.select{|k| k.strip!=""}
    all_ids.concat(category_ids)
    if category_ids.size>0
      while category_ids.size>0
        c=Category.find_by_id(category_ids.shift)
        if !c.nil? and c.children.size>0
          c.children.each do |sub_category|
            all_ids<<sub_category.id
            category_ids<<sub_category.id
          end
        end
      end
      str_category_ids_with_comma=all_ids.uniq.join(",")
      sql="select p.* from products p inner join categories_products cp on cp.product_id=p.id where cp.category_id in (#{str_category_ids_with_comma})"
    else
      sql="select * from `products` where 1=1"
    end

    list=[]
    list<< "`new`=1" if !new.blank? and new.strip!=""
    list<< "`on`=1" if !on.blank? and on.strip!=""
    list<< "`stock`>0" if !stock.blank? and stock.strip!=""
    list<< "`score`=1" if !score.blank? and score.strip!=""
    list<< "`promotion`=1" if !promotion.blank? and promotion.strip!=""
    way1=true
    if !keyword.blank? and keyword.strip!=""
      way1=false
      list<< "(`id` like ? or `name` like ? or `description` like ?)"
    end
    list.unshift(sql)
    sql=list.join(" and ")
    sql+=" order by id desc"
    logger.debug("big sql==========================")
    logger.debug("page #{page}")
    logger.debug(sql)

    if way1
      @products = Product.paginate_by_sql [sql],:per_page=>10,:page=>page
    else
      @products = Product.paginate_by_sql [sql,keyword,"%#{keyword}%","%#{keyword}%"],:per_page=>10,:page=>page
    end
    respond_to do |format|
        format.html { }
        format.js  { }
    end
    #render :template=>'search.js.erb'
  end

  # GET /products
  # GET /products.xml
  #def index
    #if params[:page].blank?
    #  page=1
    #else
    #  page=params[:page]
    #end
    #@products = Product.paginate :per_page=>15,:page=>page,:order=>["id desc"]
    #search
    #render :action=> 'search'
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.xml  { render :xml => @products }
    #end
  #end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new
    @parent  = Category.top
    @gifts   = Gift.top
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    @gifts   = Gift.top
    #render :layout=>"test"
  end

  def _product_relevent_gifts(product)
    while $q.size!
      g=Gift.find(gift_id)
      @product.gifts<<g
      q<<g.parent.id
    end
  end

  def update_product_has_gifts(product)
    product.gifts=[]
    $q=params[:gift_id] || []
    while $q.size>0
      g=Gift.find($q.shift)
      if !g.nil?
        if GiftsProduct.find_by_product_id_and_gift_id(product.id,g.id).nil?
          product.gifts<<g
        end
      end
      $q<<g.parent.id if !g.parent.nil?
    end
  end
  def update_product_has_categories(product)
    p=params[:category_id]
    if p.blank?
      return
    end
    if p.class!=[].class
      p=[p]
    end
    $q=p
    $q=$q.map{|k| k.strip}.uniq.reject{|k| k==""}
    logger.debug("----------------------------")
    logger.debug($q)
    product.categories=[]

    while $q.size>0
      c=Category.find($q.shift)
      if !c.nil?
        if CategoriesProduct.find_by_product_id_and_category_id(product.id,c.id).nil?
          product.categories<<c
        end
      end
    end
  end

  # POST /products
  # POST /products.xml
  def create

    @product = Product.new(params[:product])
    if !params[:brand_id].blank?
      @product.brand_id=params[:brand_id]
    end
    @product.category_ids=params[:category_id]
    #@product.errors[:base]<<"产品至少属于一个分类"

    logger.error("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh")
    puts "=================="
    print "------------------------------------------------"
    respond_to do |format|
      if @product.save
        update_product_has_gifts(@product)
        update_product_has_categories(@product)
        format.html { redirect_to([:admin,@product], :notice => 'Product was successfully created.') }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])
    @product.category_ids=params[:category_id]
    @product.brand_id=params[:brand_id]
    respond_to do |format|
      if @product.update_attributes(params[:product])
        update_product_has_gifts(@product)
        update_product_has_categories(@product)
        format.html { redirect_to([:admin,@product], :notice => 'Product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(admin_products_path) }
      format.xml  { head :ok }
    end
  end
end

