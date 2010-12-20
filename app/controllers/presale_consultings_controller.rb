
class PresaleConsultingsController < ApplicationController
  # GET /presale_consultings
  # GET /presale_consultings.xml
  def index
    @presale_consultings = PresaleConsulting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @presale_consultings }
    end
  end

  # GET /presale_consultings/1
  # GET /presale_consultings/1.xml
  def show
    @presale_consulting = PresaleConsulting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @presale_consulting }
    end
  end

  # GET /presale_consultings/new
  # GET /presale_consultings/new.xml
  def new
    @presale_consulting = PresaleConsulting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @presale_consulting }
    end
  end

  # GET /presale_consultings/1/edit
  def edit
    @presale_consulting = PresaleConsulting.find(params[:id])
  end

  # POST /presale_consultings
  # POST /presale_consultings.xml
  def create
    @presale_consulting = PresaleConsulting.new(params[:presale_consulting])

    respond_to do |format|
      if @presale_consulting.save
        format.html { redirect_to([@presale_consulting], :notice => 'Presale consulting was successfully created.') }
        format.xml  { render :xml => @presale_consulting, :status => :created, :location => @presale_consulting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @presale_consulting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /presale_consultings/1
  # PUT /presale_consultings/1.xml
  def update
    @presale_consulting = PresaleConsulting.find(params[:id])

    respond_to do |format|
      if @presale_consulting.update_attributes(params[:presale_consulting])
        format.html { redirect_to([@presale_consulting], :notice => 'Presale consulting was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @presale_consulting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /presale_consultings/1
  # DELETE /presale_consultings/1.xml
  def destroy
    @presale_consulting = PresaleConsulting.find(params[:id])
    @presale_consulting.destroy

    respond_to do |format|
      format.html { redirect_to(presale_consultings_url) }
      format.xml  { head :ok }
    end
  end
end
