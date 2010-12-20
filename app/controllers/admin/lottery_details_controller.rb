
class Admin::LotteryDetailsController < AdminController
  layout "admin"
  # GET /admin/lottery_details
  # GET /admin/lottery_details.xml
  def index
    @lottery_details = LotteryDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lottery_details }
    end
  end

  # GET /admin/lottery_details/1
  # GET /admin/lottery_details/1.xml
  def show
    @lottery_detail = LotteryDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lottery_detail }
    end
  end

  # GET /admin/lottery_details/new
  # GET /admin/lottery_details/new.xml
  def new
    @lottery_detail = LotteryDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lottery_detail }
    end
  end

  # GET /admin/lottery_details/1/edit
  def edit
    @lottery_detail = LotteryDetail.find(params[:id])
  end

  # POST /admin/lottery_details
  # POST /admin/lottery_details.xml
  def create
    @lottery_detail = LotteryDetail.new(params[:lottery_detail])

    respond_to do |format|
      if @lottery_detail.save
        format.html { redirect_to([:admin,@lottery_detail], :notice => 'Lottery detail was successfully created.') }
        format.xml  { render :xml => @lottery_detail, :status => :created, :location => @lottery_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lottery_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/lottery_details/1
  # PUT /admin/lottery_details/1.xml
  def update
    @lottery_detail = LotteryDetail.find(params[:id])

    respond_to do |format|
      if @lottery_detail.update_attributes(params[:lottery_detail])
        format.html { redirect_to([:admin,@lottery_detail], :notice => 'Lottery detail was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lottery_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/lottery_details/1
  # DELETE /admin/lottery_details/1.xml
  def destroy
    @lottery_detail = LotteryDetail.find(params[:id])
    @lottery_detail.destroy

    respond_to do |format|
      format.html { redirect_to(admin_lottery_details_url) }
      format.xml  { head :ok }
    end
  end
end
