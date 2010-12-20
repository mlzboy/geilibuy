
class Admin::ArticleCategoriesController < AdminController
  layout "admin"
  # GET /admin/article_categories
  # GET /admin/article_categories.xml
  def index
    @article_categories = ArticleCategory.order("tuangou").all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @article_categories }
    end
  end

  # GET /admin/article_categories/1
  # GET /admin/article_categories/1.xml
  def show
    @article_category = ArticleCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article_category }
    end
  end

  # GET /admin/article_categories/new
  # GET /admin/article_categories/new.xml
  def new
    @article_category = ArticleCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article_category }
    end
  end

  # GET /admin/article_categories/1/edit
  def edit
    @article_category = ArticleCategory.find(params[:id])
  end

  # POST /admin/article_categories
  # POST /admin/article_categories.xml
  def create
    @article_category = ArticleCategory.new(params[:article_category])

    respond_to do |format|
      if @article_category.save
        format.html { redirect_to([:admin,@article_category], :notice => 'Article category was successfully created.') }
        format.xml  { render :xml => @article_category, :status => :created, :location => @article_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/article_categories/1
  # PUT /admin/article_categories/1.xml
  def update
    @article_category = ArticleCategory.find(params[:id])

    respond_to do |format|
      if @article_category.update_attributes(params[:article_category])
        format.html { redirect_to([:admin,@article_category], :notice => 'Article category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/article_categories/1
  # DELETE /admin/article_categories/1.xml
  def destroy
    @article_category = ArticleCategory.find(params[:id])
    @article_category.destroy

    respond_to do |format|
      format.html { redirect_to(admin_article_categories_url) }
      format.xml  { head :ok }
    end
  end
end
