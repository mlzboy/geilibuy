
class Admin::CashOrdersController < AdminController
  layout "admin"
  # GET /admin/cash_orders
  # GET /admin/cash_orders.xml
  def index
    @cash_orders = CashOrder.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cash_orders }
    end
  end

  # GET /admin/cash_orders/1
  # GET /admin/cash_orders/1.xml
  def show
    @cash_order = CashOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cash_order }
    end
  end

  # GET /admin/cash_orders/new
  # GET /admin/cash_orders/new.xml
  def new
    @cash_order = CashOrder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cash_order }
    end
  end

  # GET /admin/cash_orders/1/edit
  def edit
    @cash_order = CashOrder.find(params[:id])
  end

  # POST /admin/cash_orders
  # POST /admin/cash_orders.xml
  def create
    @cash_order = CashOrder.new(params[:cash_order])

    respond_to do |format|
      if @cash_order.save
        format.html { redirect_to([:admin,@cash_order], :notice => 'Cash order was successfully created.') }
        format.xml  { render :xml => @cash_order, :status => :created, :location => @cash_order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cash_order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/cash_orders/1
  # PUT /admin/cash_orders/1.xml
  def update
    @cash_order = CashOrder.find(params[:id])

    respond_to do |format|
      if @cash_order.update_attributes(params[:cash_order])
        format.html { redirect_to([:admin,@cash_order], :notice => 'Cash order was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cash_order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/cash_orders/1
  # DELETE /admin/cash_orders/1.xml
  def destroy
    @cash_order = CashOrder.find(params[:id])
    @cash_order.destroy

    respond_to do |format|
      format.html { redirect_to(admin_cash_orders_url) }
      format.xml  { head :ok }
    end
  end
end
