class Admin::GiftsController < AdminController
  layout "admin"
  # GET /gifts
  # GET /gifts.xml
  def index
    @gifts = Gift.top
    @parent=nil
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @gifts }
    end
  end

  # GET /gifts/1
  # GET /gifts/1.xml
  def show
    @gift = Gift.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gift }
    end
  end

  # GET /gifts/new
  # GET /gifts/new.xml
  def new
    @gift = Gift.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gift }
    end
  end

  # GET /gifts/1/edit
  def edit
    @gift = Gift.find(params[:id])
  end
  
  def sub
    @parent     = Gift.find(params[:id])
    @gifts = @parent.children
    respond_to do |format|
      format.html { render :action=>'index'}
      format.js   { render :json => @gifts }
      format.xml  { render :xml => @gifts }
    end
  end

  def sub_new
    @parent = Gift.find(params[:parent_id])
    @gift=Gift.new
    @gift.parent_id=@parent.id
    respond_to do |format|
      format.html { render :action=> "new"}
      format.xml  { render :xml => @gift }
    end    
  end
  
  # POST /gifts
  # POST /gifts.xml
  def create
    @gift = Gift.new(params[:gift])

    respond_to do |format|
      if @gift.save
        format.html { redirect_to([:admin,@gift], :notice => 'Gift was successfully created.') }
        format.xml  { render :xml => @gift, :status => :created, :location => @gift }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gift.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /gifts/1
  # PUT /gifts/1.xml
  def update
    @gift = Gift.find(params[:id])

    respond_to do |format|
      if @gift.update_attributes(params[:gift])
        format.html { redirect_to([:admin,@gift], :notice => 'Gift was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gift.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gifts/1
  # DELETE /gifts/1.xml
  def destroy
    @gift = Gift.find(params[:id])
    if @gift.parent.nil?
      r=admin_gifts_path
    else
      r=admin_gifts_path+"/"+@gift.parent_id.to_s+"/sub"
    end
    @gift.destroy

    redirect_to(r)
  end
end
