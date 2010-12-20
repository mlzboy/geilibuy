
class Admin::CouponsController < AdminController
  layout "admin"
  # GET /admin/coupons
  # GET /admin/coupons.xml
  def index
    @coupons = Coupon.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @coupons }
    end
  end

  # GET /admin/coupons/1
  # GET /admin/coupons/1.xml
  def show
    @coupon = Coupon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @coupon }
    end
  end

  # GET /admin/coupons/new
  # GET /admin/coupons/new.xml
  def new
    @coupon = Coupon.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @coupon }
    end
  end

  # GET /admin/coupons/1/edit
  def edit
    @coupon = Coupon.find(params[:id])
  end

  # POST /admin/coupons
  # POST /admin/coupons.xml
  def create
    @coupon = Coupon.new(params[:coupon])

    respond_to do |format|
      if @coupon.save
        format.html { redirect_to([:admin,@coupon], :notice => 'Coupon was successfully created.') }
        format.xml  { render :xml => @coupon, :status => :created, :location => @coupon }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @coupon.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/coupons/1
  # PUT /admin/coupons/1.xml
  def update
    @coupon = Coupon.find(params[:id])

    respond_to do |format|
      if @coupon.update_attributes(params[:coupon])
        format.html { redirect_to([:admin,@coupon], :notice => 'Coupon was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @coupon.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/coupons/1
  # DELETE /admin/coupons/1.xml
  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy

    respond_to do |format|
      format.html { redirect_to(admin_coupons_url) }
      format.xml  { head :ok }
    end
  end
end
