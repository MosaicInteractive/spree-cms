class Admin::PagesController < Admin::BaseController
  uses_tiny_mce :only => [:new, :create, :edit, :update, :index], :options => {
      :editor_selector                 => 'fullwidth mceEditor',
      :theme                           => 'advanced',
      :theme_advanced_toolbar_location => 'top',
      :theme_advanced_toolbar_align    => 'left',
      :theme_advanced_buttons1         => 'bold,italic,underline,strikethrough,justifyleft,justifycenter,justifyright,justifyfull,separator,styleselect,formatselect,fontselect,fontsizeselect,removeformat,forecolor,backcolor',
      :theme_advanced_buttons2         => 'cut,copy,paste,pasteword,separator,search,replace,separator,bullist,numlist,outdent,indent,blockquote,separator,undo,redo,separator,link,unlink,anchor,image,media,code,separator,preview',
      :theme_advanced_buttons3         => 'tablecontrols,separator,hr,separator,sub,sup,separator,charmap,separator,print,fullscreen',
      :plugins                         => %w{ table fullscreen paste searchreplace advlink advimage preview  print }
    }
  resource_controller :except => [:show]
  
  
  index.response do |wants|
    wants.html { render :action => :index }
    wants.json { render :json => @collection.to_json()  }
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
    def collection

      unless request.xhr?
        # Note: the SL scopes are on/off switches, so we need to select "not_deleted" explicitly if the switch is off
        # QUERY - better as named scope or as SL scope?
        #if params[:search].nil? || params[:search][:deleted_at_not_null].blank?
        #  base_scope = base_scope.not_deleted
        #end

        @search = Page.searchlogic(params[:search])

        # @search = Post.search(params[:search])
        # @search.order ||= "ascend_by_title"

        @collection = @search.do_search.paginate(
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
