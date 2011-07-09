class Admin::PagesController < Admin::BaseController
  helper CmsHelper  
  resource_controller :except => [:show]
  
  def index
    respond_to do |wants|
      wants.html { render :action => :index }
      wants.json { render :json => @collection.to_json()  }
    end
  end
  
  new_action.response do |wants|
    wants.html {render :action => :new, :layout => false}
  end
  
  create.before :create_before

  create.response do |wants|
    # go to edit form after creating as new page
    wants.html {redirect_to edit_admin_page_url(Page.find(@page.id)) }
  end

  update.response do |wants|
    # override the default redirect behavior of r_c
    # need to reload Page in case name / permalink has changed
    wants.html {redirect_to edit_admin_page_url(Page.find(@page.id)) }
  end
  
  private
  def find_resource
    Page.find_by_permalink(params[:id])
  end
  def collection

    unless request.xhr?
      @search = Page.metasearch(params[:search])

      # @search = Post.search(params[:search])
      # @search.order ||= "ascend_by_title"

      @collection = @search.paginate(
        :per_page => (Spree::Config[:per_page]||50),
        :page     => params[:page]
      )
    else
      @collection = Page.title_contains(params[:q]).all(:include => includes, :limit => 10)
      @collection.uniq!
    end
  end
  
  # set the default published and comment status if applicable
  def create_before
    return unless Spree::Config[:cms_page_status_default]
    @page.is_active = Spree::Config[:cms_page_status_default]
  end
    
end
