
class Admin::OutOfStocksController < ApplicationController
  layout "admin"
  # GET /admin/out_of_stocks
  # GET /admin/out_of_stocks.xml
  def index
    @out_of_stocks = OutOfStock.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @out_of_stocks }
    end
  end

  # GET /admin/out_of_stocks/1
  # GET /admin/out_of_stocks/1.xml
  def show
    @out_of_stock = OutOfStock.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @out_of_stock }
    end
  end

  # GET /admin/out_of_stocks/new
  # GET /admin/out_of_stocks/new.xml
  def new
    @out_of_stock = OutOfStock.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @out_of_stock }
    end
  end

  # GET /admin/out_of_stocks/1/edit
  def edit
    @out_of_stock = OutOfStock.find(params[:id])
  end

  # POST /admin/out_of_stocks
  # POST /admin/out_of_stocks.xml
  def create
    @out_of_stock = OutOfStock.new(params[:out_of_stock])

    respond_to do |format|
      if @out_of_stock.save
        format.html { redirect_to([:admin,@out_of_stock], :notice => 'Out of stock was successfully created.') }
        format.xml  { render :xml => @out_of_stock, :status => :created, :location => @out_of_stock }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @out_of_stock.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/out_of_stocks/1
  # PUT /admin/out_of_stocks/1.xml
  def update
    @out_of_stock = OutOfStock.find(params[:id])

    respond_to do |format|
      if @out_of_stock.update_attributes(params[:out_of_stock])
        format.html { redirect_to([:admin,@out_of_stock], :notice => 'Out of stock was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @out_of_stock.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/out_of_stocks/1
  # DELETE /admin/out_of_stocks/1.xml
  def destroy
    @out_of_stock = OutOfStock.find(params[:id])
    @out_of_stock.destroy

    respond_to do |format|
      format.html { redirect_to(admin_out_of_stocks_url) }
      format.xml  { head :ok }
    end
  end
end
