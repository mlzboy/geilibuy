
class Admin::TopicsController < ApplicationController
  layout "admin"
  
  def update_topic_details
    @topic.save
    @topic.topic_details=[]

    detail_product_show_ids=params[:topic_product_show_ids]
    detail_contents=params[:topic_contents]
    logger.debug("=============TTTTTTTTTTTTTTTTTTTTTTTTTT=====")
    logger.debug(detail_product_show_ids)
    logger.debug(detail_contents)
    #details=(1..detail_titles.size).zip(detail_titles,detail_contents)
    if detail_product_show_ids and detail_product_show_ids.size>0
      details=detail_product_show_ids.zip(detail_contents)
      logger.debug("%%%%%%%%%%%%")
      logger.debug(details)
      details.each_with_index do |detail,index|
        product_show_id,content=detail
        logger.debug("&&&&&&&&&&")
        logger.debug(product_show_id)
        logger.debug(content)
        if !product_show_id.nil? or product_show_id.strip!="" or !content.nil? or content.strip!=""
            td=TopicDetail.new
            td.product_show_id=product_show_id.strip
            td.content=content.strip
            td.position=index
            logger.debug("do save--------------")
            td.save
            @topic.topic_details<<td        
        end
      end
    end
  end  
  
  
  # GET /admin/topics
  # GET /admin/topics.xml
  def index
    @topics = Topic.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /admin/topics/1
  # GET /admin/topics/1.xml
  def show
    @topic = Topic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /admin/topics/new
  # GET /admin/topics/new.xml
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /admin/topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /admin/topics
  # POST /admin/topics.xml
  def create
    @topic = Topic.new(params[:topic])
    update_topic_details

    respond_to do |format|
      if @topic.save
        format.html { redirect_to([:admin,@topic], :notice => 'Topic was successfully created.') }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/topics/1
  # PUT /admin/topics/1.xml
  def update
    @topic = Topic.find(params[:id])
    update_topic_details

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to([:admin,@topic], :notice => 'Topic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/topics/1
  # DELETE /admin/topics/1.xml
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(admin_topics_url) }
      format.xml  { head :ok }
    end
  end
end
