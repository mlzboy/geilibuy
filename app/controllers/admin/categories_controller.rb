class Admin::CategoriesController < AdminController
  layout "admin"
  # GET /categories
  # GET /categories.xml
  def index
    @categories = Admin::Category.top
    @parent=nil
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /Admin/categories/1
  # GET /Admin/categories/1.xml
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end
  
  def sub_new
    @parent = Category.find(params[:parent_id])
    @category=Category.new
    @category.parent_id=@parent.id
    respond_to do |format|
      format.html { render :action=> "new"}
      format.xml  { render :xml => @category }
    end    
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end
  
  def sub
    @parent     = Category.find(params[:id])
    @categories = @parent.children
    respond_to do |format|
      format.html { render :action=>'index'}
      format.js   { render :json => @categories }
      format.xml  { render :xml => @categories }
    end
  end
  
  #for edit product page usage,NO USED
  def ajax_ids
    q=[]
    c=Category.find_by_id(params[:id])
    if !c.nil?
      q<<c.id.to_s
      while !c.parent.nil?
        q<<c.parent.id.to_s
        c=c.parent
      end
    end
    @r=q.reverse
    #if @r.size>1
    #  @r.shift
    #end
    respond_to do |format|
      format.js {render :json=>@r}
    end
  end
  
  def ajax_ids2
    q=[]
    categories=Product.find(params[:id]).categories
    logger.error("**********************************************")
    logger.debug(categories.size)
    logger.debug(categories)
    for c in categories
      p=[]
      p<<c.id.to_s
      while !c.parent.nil?
        p<<c.parent.id.to_s
        c=c.parent
      end
      q<<p.reverse
      logger.debug("=============")
      logger.debug(q)
    end
    logger.debug("-------------")
    logger.debug(p)
    respond_to do |format|
      format.js {render :json=>q}
    end
  end  
  
  #for edit product page usage
  def ajax_sub
    @h={}
    if params[:id]==nil
      coll=Category.top
    else
      c=Category.find(params[:id])
      coll=c.children
      #@h[c.id]="parent"
    end
    for e in coll
      @h[e.id]=e.name
    end
    
    respond_to do |format|
      format.js {render :json =>@h}
    end
  end
  
  #for product edit page category ajax usage,NOT USED
  def parent
    @ancestor     = Category.find(params[:id]).parent
    if @ancestor.nil?
      @categories=[]
    else
      if @ancestor.parent.nil!
        @categories=@ancestor.parent.children
      else
        @categories=Category.top
      end
    end
    @categories = @parent.children
    respond_to do |format|
      format.html { render :action=>'index'}
      format.js   { render :json => @categories }
      format.xml  { render :xml => @categories }
    end    
  end
  
  #for product edit page category ajax usage,NOT USED
  def all
    def recursion(c)
      (0..c.children.size-1).each do |j|
        cc=c.children[j]
        $str+='"'+cc.name+'":{'
        if cc.children.size==0
          #level+=1
          $str+="\"\":#{cc.id}}"
        else
          recursion(cc)
        end
        if j!=(c.children.size-1)
          $str+=","
        else
          $str+="}"
        end
      end
    end    
    $str="{"
    $level=1
    $left=1
    $right=0
    top=Category.top
    (0..top.size-1).each do |i|
      c=top[i]
      $str+='"'+c.name+'":{'
      if c.children.size==0
        #level+=1
        $str+="\"\":#{c.id}}"
      else
        recursion(c)
      end
      if i!=(top.size-1)
        $str+=","
      else
        $str+="}"
      end
    end

    

    puts $str

    respond_to do |format|
      format.html { render :text=>$str}
      #format.js   { render :json => @options }
      #format.xml  { render :xml => @categories }
    end    
  end  

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        #[:admin,@category]==>是新创建的category的详细页
        format.html { redirect_to([:admin,@category], :notice => 'Category was successfully created.') }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to([:admin,@category], :notice => 'Category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    if @category.parent.nil?
      r="/admin/categories/"
    else
      r="/admin/categories/"+@category.parent_id.to_s+"/sub"
    end    
    q=[]
    q.push(@category)
    while q.size>0
      c=q.shift
      if c.children.size>0
        q+=c.children
      end
      c.destroy
    end
    redirect_to(r)
  end
end
