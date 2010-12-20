
class Admin::DeliveriesController < AdminController
  layout "admin"
  # GET /admin/deliveries
  # GET /admin/deliveries.xml
  def index
    @deliveries = Delivery.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deliveries }
    end
  end

  # GET /admin/deliveries/1
  # GET /admin/deliveries/1.xml
  def show
    @delivery = Delivery.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @delivery }
    end
  end

  # GET /admin/deliveries/new
  # GET /admin/deliveries/new.xml
  def new
    @delivery = Delivery.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @delivery }
    end
  end

  # GET /admin/deliveries/1/edit
  def edit
    @delivery = Delivery.find(params[:id])
  end

  # POST /admin/deliveries
  # POST /admin/deliveries.xml
  def create
    @delivery = Delivery.new(params[:delivery])

    respond_to do |format|
      if @delivery.save
        format.html { redirect_to([:admin,@delivery], :notice => 'Delivery was successfully created.') }
        format.xml  { render :xml => @delivery, :status => :created, :location => @delivery }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @delivery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/deliveries/1
  # PUT /admin/deliveries/1.xml
  def update
    @delivery = Delivery.find(params[:id])

    respond_to do |format|
      if @delivery.update_attributes(params[:delivery])
        format.html { redirect_to([:admin,@delivery], :notice => 'Delivery was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @delivery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/deliveries/1
  # DELETE /admin/deliveries/1.xml
  def destroy
    @delivery = Delivery.find(params[:id])
    @delivery.destroy

    respond_to do |format|
      format.html { redirect_to(admin_deliveries_url) }
      format.xml  { head :ok }
    end
  end
end
