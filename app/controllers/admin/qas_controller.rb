
class Admin::QasController < AdminController
  layout "admin"
  # GET /admin/qas
  # GET /admin/qas.xml
  def index
    @qas = Qa.order("id desc").all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @qas }
    end
  end

  # GET /admin/qas/1
  # GET /admin/qas/1.xml
  def show
    @qa = Qa.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @qa }
    end
  end

  # GET /admin/qas/new
  # GET /admin/qas/new.xml
  def new
    @qa = Qa.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @qa }
    end
  end

  # GET /admin/qas/1/edit
  def edit
    @qa = Qa.find(params[:id])
  end

  # POST /admin/qas
  # POST /admin/qas.xml
  def create
    @qa = Qa.new(params[:qa])

    respond_to do |format|
      if @qa.save
        format.html { redirect_to([:admin,@qa], :notice => 'Qa was successfully created.') }
        format.xml  { render :xml => @qa, :status => :created, :location => @qa }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @qa.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/qas/1
  # PUT /admin/qas/1.xml
  def update
    @qa = Qa.find(params[:id])

    respond_to do |format|
      if @qa.update_attributes(params[:qa])
        format.html { redirect_to([:admin,@qa], :notice => 'Qa was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @qa.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/qas/1
  # DELETE /admin/qas/1.xml
  def destroy
    @qa = Qa.find(params[:id])
    @qa.destroy

    respond_to do |format|
      format.html { redirect_to(admin_qas_url) }
      format.xml  { head :ok }
    end
  end
end
