
class Admin::BonusesController < AdminController
  layout "admin"
  # GET /admin/bonus
  # GET /admin/bonus.xml
  def index
    @bonuses = Bonus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bonuses }
    end
  end

  # GET /admin/bonus/1
  # GET /admin/bonus/1.xml
  def show
    @bonus = Bonus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bonus }
    end
  end

  # GET /admin/bonus/new
  # GET /admin/bonus/new.xml
  def new
    @bonus = Bonu.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bonus }
    end
  end

  # GET /admin/bonus/1/edit
  def edit
    @bonus = Bonus.find(params[:id])
  end

  # POST /admin/bonus
  # POST /admin/bonus.xml
  def create
    @bonus = Bonus.new(params[:bonus])

    respond_to do |format|
      if @bonus.save
        format.html { redirect_to([:admin,@bonus], :notice => 'Bonus was successfully created.') }
        format.xml  { render :xml => @bonus, :status => :created, :location => @bonus }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bonus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/bonus/1
  # PUT /admin/bonus/1.xml
  def update
    @bonus = Bonus.find(params[:id])

    respond_to do |format|
      if @bonu.update_attributes(params[:bonus])
        format.html { redirect_to([:admin,@bonus], :notice => 'Bonus was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bonus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/bonus/1
  # DELETE /admin/bonus/1.xml
  def destroy
    @bonus = Bonus.find(params[:id])
    @bonus.destroy

    respond_to do |format|
      format.html { redirect_to(admin_bonus_url) }
      format.xml  { head :ok }
    end
  end
end
