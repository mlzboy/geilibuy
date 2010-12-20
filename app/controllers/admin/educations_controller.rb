
class Admin::EducationsController < AdminController
  layout "admin"
  # GET /admin/educations
  # GET /admin/educations.xml
  def index
    @educations = Education.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @educations }
    end
  end

  # GET /admin/educations/1
  # GET /admin/educations/1.xml
  def show
    @education = Education.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @education }
    end
  end

  # GET /admin/educations/new
  # GET /admin/educations/new.xml
  def new
    @education = Education.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @education }
    end
  end

  # GET /admin/educations/1/edit
  def edit
    @education = Education.find(params[:id])
  end

  # POST /admin/educations
  # POST /admin/educations.xml
  def create
    @education = Education.new(params[:education])

    respond_to do |format|
      if @education.save
        format.html { redirect_to([:admin,@education], :notice => 'Education was successfully created.') }
        format.xml  { render :xml => @education, :status => :created, :location => @education }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @education.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/educations/1
  # PUT /admin/educations/1.xml
  def update
    @education = Education.find(params[:id])

    respond_to do |format|
      if @education.update_attributes(params[:education])
        format.html { redirect_to([:admin,@education], :notice => 'Education was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @education.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/educations/1
  # DELETE /admin/educations/1.xml
  def destroy
    @education = Education.find(params[:id])
    @education.destroy

    respond_to do |format|
      format.html { redirect_to(admin_educations_url) }
      format.xml  { head :ok }
    end
  end
end
