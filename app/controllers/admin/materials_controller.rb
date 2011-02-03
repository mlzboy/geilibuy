
class Admin::MaterialsController < AdminController
  layout "admin"
  
  # GET /admin/materials
  # GET /admin/materials.xml
  def index
    #@materials = Material.all
    if params[:page].blank?
      page=1
    else
      page=params[:page]
    end
    @materials = Material.paginate :per_page=>10,:page=>page,:order=>"id desc"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @materials }
    end
  end

  # GET /admin/materials/1
  # GET /admin/materials/1.xml
  def show
    @material = Material.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @material }
    end
  end

  # GET /admin/materials/new
  # GET /admin/materials/new.xml
  def new
    @material = Material.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @material }
    end
  end

  # GET /admin/materials/1/edit
  def edit
    @material = Material.find(params[:id])
  end

  # POST /admin/materials
  # POST /admin/materials.xml
  def create
    @material = Material.new(params[:material])

    respond_to do |format|
      if @material.save
        format.html { redirect_to([:admin,@material], :notice => 'Material was successfully created.') }
        format.xml  { render :xml => @material, :status => :created, :location => @material }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @material.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/materials/1
  # PUT /admin/materials/1.xml
  def update
    @material = Material.find(params[:id])

    respond_to do |format|
      if @material.update_attributes(params[:material])
        format.html { redirect_to([:admin,@material], :notice => 'Material was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @material.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/materials/1
  # DELETE /admin/materials/1.xml
  def destroy
    @material = Material.find(params[:id])
    @material.destroy

    respond_to do |format|
      format.html { redirect_to(admin_materials_url) }
      format.xml  { head :ok }
    end
  end
end
