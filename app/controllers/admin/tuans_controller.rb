
class Admin::TuansController < AdminController
  #layout "admin"
  # GET /admin/tuans
  # GET /admin/tuans.xml
  def index
    @tuans = Tuan.order("id desc").all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tuans }
    end
  end

  # GET /admin/tuans/1
  # GET /admin/tuans/1.xml
  def show
    @tuan = Tuan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tuan }
    end
  end

  # GET /admin/tuans/new
  # GET /admin/tuans/new.xml
  def new
    @tuan = Tuan.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tuan }
    end
  end

  # GET /admin/tuans/1/edit
  def edit
    @tuan = Tuan.find(params[:id])
  end

  def update_tuan_details
    @tuan.save
    @tuan.tuan_details=[]
    tips=params[:tuan_tips]
    features=params[:tuan_features]
    if tips
      tips.each_with_index do |tip,index|
        if !tip.nil? and tip.strip!=""
          td=TuanDetail.new
          td.kind="tip"
          td.title=tip.strip
          td.position=index
          td.save
          @tuan.tuan_details<<td
        end
      end
    end
    if features
      features.each_with_index do |feature,index|
        if !feature.nil? and feature.strip!=""
          td=TuanDetail.new
          td.kind="feature"
          td.title=feature.strip
          td.position=index
          td.save
          @tuan.tuan_details<<td
        end
      end
    end
    detail_titles=params[:tuan_titles]
    detail_contents=params[:tuan_contents]
    logger.debug("=============TTTTTTTTTTTTTTTTTTTTTTTTTT=====")
    logger.debug(detail_titles)
    logger.debug(detail_contents)
    #details=(1..detail_titles.size).zip(detail_titles,detail_contents)
    if detail_titles and detail_titles.size>0
      details=detail_titles.zip(detail_contents)
      logger.debug("%%%%%%%%%%%%")
      logger.debug(details)
      details.each_with_index do |detail,index|
        title,content=detail
        logger.debug("&&&&&&&&&&")
        logger.debug(title)
        logger.debug(content)
        if !title.nil? and title.strip!="" and !content.nil? and content.strip!=""
            td=TuanDetail.new
            td.kind="detail"
            td.title=title.strip
            td.content=content.strip
            td.position=index
            logger.debug("do save--------------")
            td.save
            @tuan.tuan_details<<td        
        end
      end
    end
  end
  # POST /admin/tuans
  # POST /admin/tuans.xml
  def create
    @tuan = Tuan.new(params[:tuan])
    update_tuan_details
    respond_to do |format|
      if @tuan.save
        format.html { redirect_to([:admin,@tuan], :notice => 'Tuan was successfully created.') }
        format.xml  { render :xml => @tuan, :status => :created, :location => @tuan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tuan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/tuans/1
  # PUT /admin/tuans/1.xml
  def update
    @tuan = Tuan.find(params[:id])
    update_tuan_details
    respond_to do |format|
      if @tuan.update_attributes(params[:tuan])
        format.html { redirect_to([:admin,@tuan], :notice => 'Tuan was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tuan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tuans/1
  # DELETE /admin/tuans/1.xml
  def destroy
    @tuan = Tuan.find(params[:id])
    @tuan.destroy

    respond_to do |format|
      format.html { redirect_to(admin_tuans_url) }
      format.xml  { head :ok }
    end
  end
end
