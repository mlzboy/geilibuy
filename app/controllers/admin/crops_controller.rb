class Admin::CropsController < AdminController
  #layout nil
  layout "crops"
  # GET /crops
  # GET /crops.xml
  def index
    @model_name=request.params[:model_name].capitalize
    @field_name=request.params[:field_name]
    @id=request.params[:id]
    @url=request.params[:url]
    str=<<CODE
    @model=#{@model_name}.find_by_id(#{@id})
    @field=@model.#{@field_name}
CODE
    eval(str)
    logger.debug("==========")
    logger.debug(@model_name)
    logger.debug(@field_name)
    logger.debug(@model)
    logger.debug(@field)
    logger.debug(@id)
    logger.debug(@url)


    respond_to do |format|
      format.html # index.html.erb
    end
  end


  def update
    @model_name=request.params[:model_name].capitalize
    @field_name=request.params[:field_name]
    @id=request.params[:id]
    #@url=request.params[:url]
    crop_x=request.params[:crop_x]
    crop_y=request.params[:crop_y]
    crop_w=request.params[:crop_w]
    crop_h=request.params[:crop_h]
    str=<<CODE
    @model=#{@model_name}.find_by_id(#{@id})
CODE
    eval(str)
    @model.crop_x=crop_x
    @model.crop_y=crop_y
    @model.crop_w=crop_w
    @model.crop_h=crop_h
    @model.crop_f=@field_name
    @model.save
    logger.debug(@model.class)
    

    logger.debug(crop_x)
    logger.debug(crop_y)
    logger.debug(crop_w)
    logger.debug(crop_h)
    respond_to do |format|
      if @model.save
        format.html { redirect_to([:admin,@model], :notice => 'Upload was successfully created.') }
        format.xml  { render :xml => @model, :status => :created, :location => @model }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @model.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def restore
    @model_name=request.params[:model_name].capitalize
    @field_name=request.params[:field_name]
    @id=request.params[:id]
    @url=request.params[:url]
    str=<<CODE
    @model=#{@model_name}.find_by_id(#{@id})
    @model.#{@field_name}=@model.#{@field_name}
CODE
    eval(str)
    respond_to do |format|
      if @model.save
        format.html { redirect_to([:admin,@model], :notice => 'Upload was successfully created.') }

      else
        format.html { render :action => "new" }

      end
    end
  end




end