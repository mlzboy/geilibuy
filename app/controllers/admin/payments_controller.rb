
class Admin::PaymentsController < AdminController
  layout "admin"
  
  def sub
    @parent     = Payment.find(params[:id])
    @payments = @parent.children
    respond_to do |format|
      format.html { render :action=>'index'}
      #format.js   { render :json => @categories }
      #format.xml  { render :xml => @categories }
    end
  end  
  
  # GET /admin/payments
  # GET /admin/payments.xml
  def index
    @payments = Payment.top

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payments }
    end
  end

  # GET /admin/payments/1
  # GET /admin/payments/1.xml
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  # GET /admin/payments/new
  # GET /admin/payments/new.xml
  def new
    @payment = Payment.new
    unless params[:parent_id].blank?
      @payment.parent_id=params[:parent_id].to_i
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  # GET /admin/payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
  end

  # POST /admin/payments
  # POST /admin/payments.xml
  def create
    @payment = Payment.new(params[:payment])

    respond_to do |format|
      if @payment.save
        format.html { redirect_to([:admin,@payment], :notice => 'Payment was successfully created.') }
        format.xml  { render :xml => @payment, :status => :created, :location => @payment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/payments/1
  # PUT /admin/payments/1.xml
  def update
    @payment = Payment.find(params[:id])

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to([:admin,@payment], :notice => 'Payment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/payments/1
  # DELETE /admin/payments/1.xml
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to(admin_payments_url) }
      format.xml  { head :ok }
    end
  end
end
