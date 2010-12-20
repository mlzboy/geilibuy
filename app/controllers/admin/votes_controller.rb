
class Admin::VotesController < AdminController
  layout "admin"

  def sub
    @parent     = Vote.find(params[:id])
    @votes = @parent.children
    respond_to do |format|
      format.html { render :action=>'index'}
      format.js   { render :json => @categories }
      format.xml  { render :xml => @categories }
    end
  end  
  
  # GET /admin/votes
  # GET /admin/votes.xml
  def index
    @votes = Vote.top

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @votes }
    end
  end

  # GET /admin/votes/1
  # GET /admin/votes/1.xml
  def show
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  # GET /admin/votes/new
  # GET /admin/votes/new.xml
  def new
    @vote = Vote.new
    parent_id=params[:parent_id]
    @vote.parent_id=parent_id.to_i unless parent_id.blank?
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  # GET /admin/votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /admin/votes
  # POST /admin/votes.xml
  def create
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if @vote.save
        format.html { redirect_to([:admin,@vote], :notice => 'Vote was successfully created.') }
        format.xml  { render :xml => @vote, :status => :created, :location => @vote }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/votes/1
  # PUT /admin/votes/1.xml
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        format.html { redirect_to([:admin,@vote], :notice => 'Vote was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/votes/1
  # DELETE /admin/votes/1.xml
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to(admin_votes_url) }
      format.xml  { head :ok }
    end
  end
end
