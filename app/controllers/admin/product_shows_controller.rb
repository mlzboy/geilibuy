
class Admin::ProductShowsController < AdminController
  layout "admin"
  # GET /admin/product_shows
  # GET /admin/product_shows.xml
  def index
    #@product_shows = ProductShow.all
    if params[:page].blank?
      page=1
    else
      page=params[:page]
    end
    @product_shows = ProductShow.paginate :per_page=>20,:page=>page,:order=>["id desc"]
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_shows }
    end
  end

  # GET /admin/product_shows/1
  # GET /admin/product_shows/1.xml
  def show
    @product_show = ProductShow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_show }
    end
  end
  
  def _pre_data()
    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    @products=Product.paginate :per_page=>5,:page=>page,:conditions=>"`on`=1"
    #@sizes=Material.find_by_sql("select distinct size from materials").map{|e| e.size}.uniq
    #if !@sizes.include? ""
    #  @sizes.unshift ""
    #end
    #@kinds=Material.find_by_sql("select distinct kind from materials").map{|e| e.kind}.uniq
    #if !@kinds.include? ""
    #  @kinds.unshift ""
    #end    
  end
  
  # GET /admin/slots/new
  # GET /admin/slots/new.xml
  def new
    @product_show = ProductShow.new
    _pre_data
    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.xml  { render :xml => @slot }
    #end
  end

  def query
    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    #kind=params[:kind]
    #size=params[:size]
    keyword=params[:keyword]
    condition={}
    #condition["kind"]=kind if !kind.blank? and kind.strip!=""
    #condition["size"]=size if !size.blank? and size.strip!=""
    condition["name"]=keyword if !keyword.blank? and keyword.strip()!=""
    condition["memo"]=keyword if !keyword.blank? and keyword.strip()!=""
    list=[]
    condition.each do |k,v|
      list<<"#{k} like '%#{v}%'"
    end
    list<<"`on`=1"
    if list.size>0
          condition=list.join(" and ")
    else
        condition=""
    end
    
    logger.debug(condition)
    logger.debug("===================")
    @products=Product.paginate :per_page=>5,:page=>page,:conditions=>condition
    render :action=>"new"
  end
  
  # GET /admin/slots/1/edit
  def edit
    @product_show = ProductShow.find(params[:id])
    _pre_data
    render :action=>'new'
  end
  
  def update_product_show_has_products(product_show)
    p=params[:product_id]
    if p.blank? or p.size==0
      product_show.products=[]
      return
    end
    $q=p
    $q=$q.map{|k| k.strip}.uniq.reject{|k| k==""}
    logger.debug("----------------------------")
    logger.debug($q)
    product_show.products=[]
    
    count=0
    while $q.size>0
      p=Product.find($q.shift)
      if !p.nil?
        if ProductShowsProduct.find_by_product_id_and_product_show_id(p.id,product_show.id).nil?
          n=ProductShowsProduct.new
          n.product_id=p.id
          n.product_show_id=product_show.id
          n.position=count
          n.save
          count+=1
        end
      end
    end
  end
  # POST /admin/slots
  # POST /admin/slots.xml
  def create
    @product_show = ProductShow.new(params[:product_show])
    @product_show.category_id=params[:category_id]
    respond_to do |format|
      if @product_show.save
		  update_product_show_has_products(@product_show)
        format.html { redirect_to([:admin,@product_show], :notice => 'Product show was successfully created.') }
        format.xml  { render :xml => @product_show, :status => :created, :location => @product_show }
      else
        _pre_data
        format.html { render :action => "new" }
        format.xml  { render :xml => @product_show.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/product_shows/1
  # PUT /admin/product_shows/1.xml
  def update
    @product_show = ProductShow.find(params[:id])
    @product_show.category_id=params[:category_id]
    logger.debug("===================================")
    logger.debug(params[:category_id])
    respond_to do |format|
      if @product_show.update_attributes(params[:product_show])
        update_product_show_has_products(@product_show)
        format.html { redirect_to([:admin,@product_show], :notice => 'Product show was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_show.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_shows/1
  # DELETE /admin/product_shows/1.xml
  def destroy
    @product_show = ProductShow.find(params[:id])
    @product_show.destroy

    respond_to do |format|
      format.html { redirect_to(admin_product_shows_url) }
      format.xml  { head :ok }
    end
  end
end
