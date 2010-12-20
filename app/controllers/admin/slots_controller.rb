
class Admin::SlotsController < AdminController
  layout "admin"
  #layout "test"
  # GET /admin/slots
  # GET /admin/slots.xml
  def index
    #@slots = Slot.all
    if params[:page].blank?
      page=1
    else
      page=params[:page]
    end
    @slots = Slot.paginate :per_page=>20,:page=>page,:order=>["id desc"]
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @slots }
    end
  end

  # GET /admin/slots/1
  # GET /admin/slots/1.xml
  def show
    @slot = Slot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @slot }
    end
  end
  
  def _pre_data()
    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    @materials=Material.paginate :per_page=>5,:page=>page
    @sizes=Material.find_by_sql("select distinct size from materials").map{|e| e.size}.uniq
    if !@sizes.include? ""
      @sizes.unshift ""
    end
    @kinds=Material.find_by_sql("select distinct kind from materials").map{|e| e.kind}.uniq
    if !@kinds.include? ""
      @kinds.unshift ""
    end    
  end
  
  # GET /admin/slots/new
  # GET /admin/slots/new.xml
  def new
    @slot = Slot.new
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
    kind=params[:kind]
    size=params[:size]
    keyword=params[:keyword]
    condition={}
    condition["kind"]=kind if !kind.blank? and kind.strip!=""
    condition["size"]=size if !size.blank? and size.strip!=""
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
    @materials=Material.paginate :per_page=>5,:page=>page,:conditions=>condition
    render :action=>"new"
  end
  
  # GET /admin/slots/1/edit
  def edit
    @slot = Slot.find(params[:id])
    _pre_data
    render :action=>'new'
  end
  
  def update_slot_has_materials(slot)
    p=params[:material_id]
    if p.blank? or p.size==0
      slot.materials=[]
      return
    end
    $q=p
    $q=$q.map{|k| k.strip}.uniq.reject{|k| k==""}
    logger.debug("----------------------------")
    logger.debug($q)
    slot.materials=[]
    
    count=0
    while $q.size>0
      m=Material.find($q.shift)
      if !m.nil?
        if MaterialsSlot.find_by_material_id_and_slot_id(m.id,slot.id).nil?
          n=MaterialsSlot.new
          n.material_id=m.id
          n.slot_id=slot.id
          n.position=count
          n.save
          count+=1
        end
      end
    end
  end
  # POST /admin/slots
  # POST /admin/slots.xml
  def create
    @slot = Slot.new(params[:slot])
    @slot.category_id=params[:category_id]
    respond_to do |format|
      if @slot.save
        update_slot_has_materials(@slot)
        format.html { redirect_to([:admin,@slot], :notice => 'Slot was successfully created.') }
        format.xml  { render :xml => @slot, :status => :created, :location => @slot }
      else
        _pre_data
        format.html { render :action => "new" }
        format.xml  { render :xml => @slot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/slots/1
  # PUT /admin/slots/1.xml
  def update
    @slot = Slot.find(params[:id])
    @slot.category_id=params[:category_id]
    respond_to do |format|
      if @slot.update_attributes(params[:slot])
        update_slot_has_materials(@slot)

        format.html { redirect_to([:admin,@slot], :notice => 'Slot was successfully updated.') }
        format.xml  { head :ok }
      else
        _pre_data
        format.html { render :action => "edit" }
        format.xml  { render :xml => @slot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/slots/1
  # DELETE /admin/slots/1.xml
  def destroy
    @slot = Slot.find(params[:id])
    @slot.destroy

    respond_to do |format|
      format.html { redirect_to(admin_slots_url) }
      format.xml  { head :ok }
    end
  end
end
