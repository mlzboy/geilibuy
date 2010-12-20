
class Admin::ScoreDetailsController < AdminController
  layout "admin"
  # GET /admin/score_details
  # GET /admin/score_details.xml
  def index
    @score_details = ScoreDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @score_details }
    end
  end

  # GET /admin/score_details/1
  # GET /admin/score_details/1.xml
  def show
    @score_detail = ScoreDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @score_detail }
    end
  end

  # GET /admin/score_details/new
  # GET /admin/score_details/new.xml
  def new
    @score_detail = ScoreDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @score_detail }
    end
  end

  # GET /admin/score_details/1/edit
  def edit
    @score_detail = ScoreDetail.find(params[:id])
  end

  # POST /admin/score_details
  # POST /admin/score_details.xml
  def create
    @score_detail = ScoreDetail.new(params[:score_detail])

    respond_to do |format|
      if @score_detail.save
        format.html { redirect_to([:admin,@score_detail], :notice => 'Score detail was successfully created.') }
        format.xml  { render :xml => @score_detail, :status => :created, :location => @score_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @score_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/score_details/1
  # PUT /admin/score_details/1.xml
  def update
    @score_detail = ScoreDetail.find(params[:id])

    respond_to do |format|
      if @score_detail.update_attributes(params[:score_detail])
        format.html { redirect_to([:admin,@score_detail], :notice => 'Score detail was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @score_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/score_details/1
  # DELETE /admin/score_details/1.xml
  def destroy
    @score_detail = ScoreDetail.find(params[:id])
    @score_detail.destroy

    respond_to do |format|
      format.html { redirect_to(admin_score_details_url) }
      format.xml  { head :ok }
    end
  end
end
