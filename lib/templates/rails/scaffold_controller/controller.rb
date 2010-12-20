<%
def remove_module_name(str)
  a=file_path.split("/")
  if a.size==1
    r=str
  else
    a.pop
    pre=""
    pre2=""
    for e in a
      pre+=e+"_"
      pre2+=e.capitalize+"::"
    end
    if str.index(pre)==0
      r=str[pre.size,str.size]
    elsif str.index(pre2)==0
      r=str[pre2.size,str.size]
    else
      r=str
    end
  end
  r
end

def gen_path
  a=file_path.split("/")
  if a.size==1
    r="@"+remove_module_name(singular_table_name)
  else
    a.pop
    a=a.map{|e| ":"+e}<<"@"+remove_module_name(singular_table_name)
    r=a.join(',')
  end
  "[#{r}]"
end
%>
class <%= controller_class_name %>Controller < ApplicationController
  layout "admin"
  # GET <%= route_url %>
  # GET <%= route_url %>.xml
  def index
    @<%= remove_module_name plural_table_name %> = <%=remove_module_name orm_class.all(class_name) %>

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= remove_module_name plural_table_name %> }
    end
  end

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.xml
  def show
    @<%= remove_module_name singular_table_name %> = <%=remove_module_name orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= remove_module_name singular_table_name %> }
    end
  end

  # GET <%= route_url %>/new
  # GET <%= route_url %>/new.xml
  def new
    @<%= remove_module_name singular_table_name %> = <%=remove_module_name orm_class.build(class_name) %>

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @<%= remove_module_name singular_table_name %> }
    end
  end

  # GET <%= route_url %>/1/edit
  def edit
    @<%= remove_module_name singular_table_name %> = <%=remove_module_name orm_class.find(class_name, "params[:id]") %>
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.xml
  def create
    @<%= remove_module_name singular_table_name %> = <%=remove_module_name orm_class.build(class_name, "params[:#{remove_module_name singular_table_name}]") %>

    respond_to do |format|
      if @<%= remove_module_name orm_instance.save %>
        format.html { redirect_to(<%= gen_path %>, :notice => '<%= human_name %> was successfully created.') }
        format.xml  { render :xml => @<%= remove_module_name singular_table_name %>, :status => :created, :location => @<%= remove_module_name singular_table_name %> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= remove_module_name orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  # PUT <%= route_url %>/1
  # PUT <%= route_url %>/1.xml
  def update
    @<%= remove_module_name singular_table_name %> = <%=remove_module_name orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      if @<%= remove_module_name orm_instance.update_attributes("params[:#{remove_module_name singular_table_name}]") %>
        format.html { redirect_to(<%= gen_path %>, :notice => '<%= human_name %> was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= remove_module_name orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.xml
  def destroy
    @<%= remove_module_name singular_table_name %> = <%=remove_module_name orm_class.find(class_name, "params[:id]") %>
    @<%= remove_module_name orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to(<%= index_helper %>_url) }
      format.xml  { head :ok }
    end
  end
end
