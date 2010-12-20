
class Admin::DeliveryTimesController < AdminController
  layout "admin"
  # GET /admin/delivery_times
  # GET /admin/delivery_times.xml
  def index
    @delivery_times = DeliveryTime.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @delivery_times }
    end
  end

  # GET /admin/delivery_times/1
  # GET /admin/delivery_times/1.xml
  def show
    @delivery_time = DeliveryTime.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @delivery_time }
    end
  end

  # GET /admin/delivery_times/new
  # GET /admin/delivery_times/new.xml
  def new
    @delivery_time = DeliveryTime.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @delivery_time }
    end
  end

  # GET /admin/delivery_times/1/edit
  def edit
    @delivery_time = DeliveryTime.find(params[:id])
  end

  # POST /admin/delivery_times
  # POST /admin/delivery_times.xml
  def create
    @delivery_time = DeliveryTime.new(params[:delivery_time])

    respond_to do |format|
      if @delivery_time.save
        format.html { redirect_to([:admin,@delivery_time], :notice => 'Delivery time was successfully created.') }
        format.xml  { render :xml => @delivery_time, :status => :created, :location => @delivery_time }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @delivery_time.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/delivery_times/1
  # PUT /admin/delivery_times/1.xml
  def update
    @delivery_time = DeliveryTime.find(params[:id])

    respond_to do |format|
      if @delivery_time.update_attributes(params[:delivery_time])
        format.html { redirect_to([:admin,@delivery_time], :notice => 'Delivery time was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @delivery_time.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/delivery_times/1
  # DELETE /admin/delivery_times/1.xml
  def destroy
    @delivery_time = DeliveryTime.find(params[:id])
    @delivery_time.destroy

    respond_to do |format|
      format.html { redirect_to(admin_delivery_times_url) }
      format.xml  { head :ok }
    end
  end
end
