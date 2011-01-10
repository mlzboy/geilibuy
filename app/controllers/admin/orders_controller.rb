#coding:utf-8
class Admin::OrdersController < AdminController
  layout "admin"
  # GET /admin/orders
  # GET /admin/orders.xml
  def index
    @orders = Order.order("id desc").all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /admin/orders/1
  # GET /admin/orders/1.xml
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /admin/orders/new
  # GET /admin/orders/new.xml
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /admin/orders/1/edit
  def edit
    @order = Order.find(params[:id])

  end

  # POST /admin/orders
  # POST /admin/orders.xml
  def create
    @order = Order.new(params[:order])
    unless @order.delivery_company_id.blank?
      @order.delivery_company_name=DeliveryCompany.find(@order.delivery_company_id).name
    end
    respond_to do |format|
      if @order.save
        format.html { redirect_to([:admin,@order], :notice => 'Order was successfully created.') }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/orders/1
  # PUT /admin/orders/1.xml
  def update
    @order = Order.find(params[:id])
    unless @order.delivery_company_id.blank?
      @order.delivery_company_name=DeliveryCompany.find(@order.delivery_company_id).name
    else
      @order.delivery_company_name=""
    end
    order_status_id=params[:order_status_id].to_i
    if @order.current_order_status.id!=order_status_id
      dict={}
      dict[1]="未确认"
      dict[2]="确认"
      dict[4]="正在配货"
      dict[8]="配货完成"
      dict[16]="已发货"
      dict[64]="取消"
      dict[128]="过期"
#如果订单标记为退货，则积分不返还，这样就省事一些，退货得退钱到现金账户，没有考虑细节，比如部分退换货
      @order.order_statuses << OrderStatus.create(:name=>dict[order_status_id],:value=>order_status_id,:tuangou=>false,:from=>"后台订单管理",:url=>request.fullpath)
      if order_status_id==16 and @order.tuangou==true
        email=@order.user.email
        email="frederick.mao@gmail.com"
        title=@order.tuan.sub_title#以后改成edm_title
        mail=TuanMail.order_send(@order,email,title)
        mail.deliver        
        logger.debug("TTTTTTTTTTTTREEEEEEEEEEEEEEEEEEEEE")
      elsif order_status_id==16 and @order.tuangou==false
        CoreMail.order_send(@order).deliver
        logger.debug("发送已发货邮件")
      end
    end
    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to([:admin,@order], :notice => 'Order was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/orders/1
  # DELETE /admin/orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(admin_orders_url) }
      format.xml  { head :ok }
    end
  end
end

