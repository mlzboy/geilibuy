
class Admin::CommentShowsController < AdminController
  layout "admin"
  # GET /admin/comment_shows
  # GET /admin/comment_shows.xml
  def index
    @comment_shows = CommentShow.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comment_shows }
    end
  end

  # GET /admin/comment_shows/1
  # GET /admin/comment_shows/1.xml
  def show
    @comment_show = CommentShow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment_show }
    end
  end

  # GET /admin/comment_shows/new
  # GET /admin/comment_shows/new.xml
  def new
    @comment_show = CommentShow.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment_show }
    end
  end

  # GET /admin/comment_shows/1/edit
  def edit
    @comment_show = CommentShow.find(params[:id])
  end

  # POST /admin/comment_shows
  # POST /admin/comment_shows.xml
  def create
    @comment_show = CommentShow.new(params[:comment_show])

    respond_to do |format|
      if @comment_show.save
        format.html { redirect_to([:admin,@comment_show], :notice => 'Comment show was successfully created.') }
        format.xml  { render :xml => @comment_show, :status => :created, :location => @comment_show }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment_show.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/comment_shows/1
  # PUT /admin/comment_shows/1.xml
  def update
    @comment_show = CommentShow.find(params[:id])

    respond_to do |format|
      if @comment_show.update_attributes(params[:comment_show])
        format.html { redirect_to([:admin,@comment_show], :notice => 'Comment show was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment_show.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/comment_shows/1
  # DELETE /admin/comment_shows/1.xml
  def destroy
    @comment_show = CommentShow.find(params[:id])
    @comment_show.destroy

    respond_to do |format|
      format.html { redirect_to(admin_comment_shows_url) }
      format.xml  { head :ok }
    end
  end
end
