#coding:utf-8
class Admin::CommentShowsController < AdminController
  layout "admin"
  # GET /admin/comment_shows
  # GET /admin/comment_shows.xml
  def index
    #@comment_shows = ProductShow.all
    if params[:page].blank?
      page=1
    else
      page=params[:page]
    end
    @comment_shows = CommentShow.paginate :per_page=>20,:page=>page,:order=>"id desc"
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
  
  def _pre_data()
    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    @postsale_comments=PostsaleComment.paginate :per_page=>5,:page=>page
    #@sizes=Material.find_by_sql("select distinct size from materials").map{|e| e.size}.uniq
    #if !@sizes.include? ""
    #  @sizes.unshift ""
    #end
    #@kinds=Material.find_by_sql("select distinct kind from materials").map{|e| e.kind}.uniq
    #if !@kinds.include? ""
    #  @kinds.unshift ""
    #end    
  end
  
  # GET /admin/slots/new
  # GET /admin/slots/new.xml
  def new
    @comment_show = CommentShow.new
    _pre_data
    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.xml  { render :xml => @slot }
    #end
  end

  def query
    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    #kind=params[:kind]
    #size=params[:size]
    keyword=params[:keyword]
    condition={}
    #condition["kind"]=kind if !kind.blank? and kind.strip!=""
    #condition["size"]=size if !size.blank? and size.strip!=""
    condition["name"]=keyword if !keyword.blank? and keyword.strip()!=""
    condition["memo"]=keyword if !keyword.blank? and keyword.strip()!=""
    list=[]
    condition.each do |k,v|
      list<<"#{k} like '%#{v}%'"
    end
    if list.size>0
          condition=list.join(" and ")
    else
        condition=""
    end
    
    logger.debug(condition)
    logger.debug("===================")
    @products=Product.paginate :per_page=>5,:page=>page,:conditions=>condition
    render :action=>"new"
  end

  # GET /admin/comment_shows/1/edit
  def edit
    @comment_show = CommentShow.find(params[:id])
    _pre_data
    render :action=>'new'
  end
  
  def update_comment_show_has_products(comment_show)
    p=params[:comment_id]
    if p.blank? or p.size==0
      comment_show.postsale_comments=[]
      return
    end
    $q=p
    $q=$q.map{|k| k.strip}.uniq.reject{|k| k==""}
    logger.debug("------土土----------------------")
    logger.debug($q)
    comment_show.postsale_comments=[]
    
    count=0
    while $q.size>0
      p=PostsaleComment.find($q.shift)
      if !p.nil?
        if CommentShowsPostsaleComment.find_by_postsale_comment_id_and_comment_show_id(p.id,comment_show.id).nil?
          n=CommentShowsPostsaleComment.new
          n.postsale_comment_id=p.id
          n.comment_show_id=comment_show.id
          n.position=count
          n.save
          count+=1
        end
      end
    end
  end
  # POST /admin/comment_shows
  # POST /admin/comment_shows.xml
  def create
    @comment_show = CommentShow.new(params[:comment_show])
    @comment_show.category_id=params[:category_id]
    respond_to do |format|
      if @comment_show.save
	update_comment_show_has_products(@comment_show)
        format.html { redirect_to([:admin,@comment_show], :notice => 'Comment show was successfully created.') }
        format.xml  { render :xml => @comment_show, :status => :created, :location => @comment_show }
      else
        _pre_data
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment_show.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/comment_shows/1
  # PUT /admin/comment_shows/1.xml
  def update
    @comment_show = CommentShow.find(params[:id])
    @comment_show.category_id=params[:category_id]
    #logger.debug("===================================")
    #logger.debug(params[:category_id])
    respond_to do |format|
      if @comment_show.update_attributes(params[:comment_show])
        update_comment_show_has_products(@comment_show)
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
