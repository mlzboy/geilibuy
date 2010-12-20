
class Admin::LotteriesController < AdminController
  layout "admin"
  # GET /admin/lotteries
  # GET /admin/lotteries.xml
  def index
    @lotteries = Lottery.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lotteries }
    end
  end

  # GET /admin/lotteries/1
  # GET /admin/lotteries/1.xml
  def show
    @lottery = Lottery.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lottery }
    end
  end

  # GET /admin/lotteries/new
  # GET /admin/lotteries/new.xml
  def new
    @lottery = Lottery.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lottery }
    end
  end

  # GET /admin/lotteries/1/edit
  def edit
    @lottery = Lottery.find(params[:id])
  end

  # POST /admin/lotteries
  # POST /admin/lotteries.xml
  def create
    @lottery = Lottery.new(params[:lottery])

    respond_to do |format|
      if @lottery.save
        format.html { redirect_to([:admin,@lottery], :notice => 'Lottery was successfully created.') }
        format.xml  { render :xml => @lottery, :status => :created, :location => @lottery }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lottery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/lotteries/1
  # PUT /admin/lotteries/1.xml
  def update
    @lottery = Lottery.find(params[:id])

    respond_to do |format|
      if @lottery.update_attributes(params[:lottery])
        format.html { redirect_to([:admin,@lottery], :notice => 'Lottery was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lottery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/lotteries/1
  # DELETE /admin/lotteries/1.xml
  def destroy
    @lottery = Lottery.find(params[:id])
    @lottery.destroy

    respond_to do |format|
      format.html { redirect_to(admin_lotteries_url) }
      format.xml  { head :ok }
    end
  end
end
