
class Admin::FreeShippingRulesController < ApplicationController
  layout "admin"
  # GET /admin/free_shipping_rules
  # GET /admin/free_shipping_rules.xml
  def index
    @free_shipping_rules = FreeShippingRule.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @free_shipping_rules }
    end
  end

  # GET /admin/free_shipping_rules/1
  # GET /admin/free_shipping_rules/1.xml
  def show
    @free_shipping_rule = FreeShippingRule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @free_shipping_rule }
    end
  end

  # GET /admin/free_shipping_rules/new
  # GET /admin/free_shipping_rules/new.xml
  def new
    @free_shipping_rule = FreeShippingRule.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @free_shipping_rule }
    end
  end

  # GET /admin/free_shipping_rules/1/edit
  def edit
    @free_shipping_rule = FreeShippingRule.find(params[:id])
  end

  # POST /admin/free_shipping_rules
  # POST /admin/free_shipping_rules.xml
  def create
    @free_shipping_rule = FreeShippingRule.new(params[:free_shipping_rule])

    respond_to do |format|
      if @free_shipping_rule.save
        format.html { redirect_to([:admin,@free_shipping_rule], :notice => 'Free shipping rule was successfully created.') }
        format.xml  { render :xml => @free_shipping_rule, :status => :created, :location => @free_shipping_rule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @free_shipping_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/free_shipping_rules/1
  # PUT /admin/free_shipping_rules/1.xml
  def update
    @free_shipping_rule = FreeShippingRule.find(params[:id])

    respond_to do |format|
      if @free_shipping_rule.update_attributes(params[:free_shipping_rule])
        format.html { redirect_to([:admin,@free_shipping_rule], :notice => 'Free shipping rule was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @free_shipping_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/free_shipping_rules/1
  # DELETE /admin/free_shipping_rules/1.xml
  def destroy
    @free_shipping_rule = FreeShippingRule.find(params[:id])
    @free_shipping_rule.destroy

    respond_to do |format|
      format.html { redirect_to(admin_free_shipping_rules_url) }
      format.xml  { head :ok }
    end
  end
end
