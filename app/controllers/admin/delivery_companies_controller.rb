
class Admin::DeliveryCompaniesController < AdminController
  layout "admin"
  # GET /admin/delivery_companies
  # GET /admin/delivery_companies.xml
  def index
    @delivery_companies = DeliveryCompany.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @delivery_companies }
    end
  end

  # GET /admin/delivery_companies/1
  # GET /admin/delivery_companies/1.xml
  def show
    @delivery_company = DeliveryCompany.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @delivery_company }
    end
  end

  # GET /admin/delivery_companies/new
  # GET /admin/delivery_companies/new.xml
  def new
    @delivery_company = DeliveryCompany.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @delivery_company }
    end
  end

  # GET /admin/delivery_companies/1/edit
  def edit
    @delivery_company = DeliveryCompany.find(params[:id])
  end

  # POST /admin/delivery_companies
  # POST /admin/delivery_companies.xml
  def create
    @delivery_company = DeliveryCompany.new(params[:delivery_company])

    respond_to do |format|
      if @delivery_company.save
        format.html { redirect_to([:admin,@delivery_company], :notice => 'Delivery company was successfully created.') }
        format.xml  { render :xml => @delivery_company, :status => :created, :location => @delivery_company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @delivery_company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/delivery_companies/1
  # PUT /admin/delivery_companies/1.xml
  def update
    @delivery_company = DeliveryCompany.find(params[:id])

    respond_to do |format|
      if @delivery_company.update_attributes(params[:delivery_company])
        format.html { redirect_to([:admin,@delivery_company], :notice => 'Delivery company was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @delivery_company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/delivery_companies/1
  # DELETE /admin/delivery_companies/1.xml
  def destroy
    @delivery_company = DeliveryCompany.find(params[:id])
    @delivery_company.destroy

    respond_to do |format|
      format.html { redirect_to(admin_delivery_companies_url) }
      format.xml  { head :ok }
    end
  end
end
