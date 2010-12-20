
class Admin::PostsaleCommentsController < AdminController
  layout "admin"
  # GET /admin/postsale_comments
  # GET /admin/postsale_comments.xml
  def index
    @postsale_comments = PostsaleComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @postsale_comments }
    end
  end

  # GET /admin/postsale_comments/1
  # GET /admin/postsale_comments/1.xml
  def show
    @postsale_comment = PostsaleComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @postsale_comment }
    end
  end

  # GET /admin/postsale_comments/new
  # GET /admin/postsale_comments/new.xml
  def new
    @postsale_comment = PostsaleComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @postsale_comment }
    end
  end

  # GET /admin/postsale_comments/1/edit
  def edit
    @postsale_comment = PostsaleComment.find(params[:id])
  end

  # POST /admin/postsale_comments
  # POST /admin/postsale_comments.xml
  def create
    @postsale_comment = PostsaleComment.new(params[:postsale_comment])

    respond_to do |format|
      if @postsale_comment.save
        format.html { redirect_to([:admin,@postsale_comment], :notice => 'Postsale comment was successfully created.') }
        format.xml  { render :xml => @postsale_comment, :status => :created, :location => @postsale_comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @postsale_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/postsale_comments/1
  # PUT /admin/postsale_comments/1.xml
  def update
    @postsale_comment = PostsaleComment.find(params[:id])

    respond_to do |format|
      if @postsale_comment.update_attributes(params[:postsale_comment])
        format.html { redirect_to([:admin,@postsale_comment], :notice => 'Postsale comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @postsale_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/postsale_comments/1
  # DELETE /admin/postsale_comments/1.xml
  def destroy
    @postsale_comment = PostsaleComment.find(params[:id])
    @postsale_comment.destroy

    respond_to do |format|
      format.html { redirect_to(admin_postsale_comments_url) }
      format.xml  { head :ok }
    end
  end
end
