# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class CmsExtension < Spree::Extension
  version "1.0"
  description "A blog / static-page extension for spree"
  url "http://github.com/jacobwg/spree-cms"

  # Please use blog/config/routes.rb instead for extension routes.

  def self.require_gems(config)
    config.gem 'is_taggable'
    config.gem 'RedCloth'
    config.gem 'disqus'
    config.gem 'tiny_mce'
    config.gem "htmlentities"
    config.gem "fastercsv"
  end
  
  def activate

    Disqus::defaults[:account] = "YOUR_ACCOUNT_USERNAME"
    # Optional, only if you're using the API
    Disqus::defaults[:api_key] = "YOUR_API_KEY"    
    unless RAILS_ENV == "production"
      Disqus::defaults[:developer] = true
    end

    # make your helper avaliable in all views
    Spree::BaseController.class_eval do
      helper CmsHelper      
      
      before_filter :render_page_if_exists
      
      def render_page_if_exists
        # Using request.path allows us to override dynamic pages including
        # the home page, product and taxon pages. params[:path] is only good
        # for requests that get as far as content_controller. params[:path]
        # query left in for backwards compatibility for slugs that don't start
        # with a slash.
        @page = Page.publish.find_by_permalink(params[:path]) if params[:path]
        @page = Page.publish.find_by_permalink(request.path) unless @page
        render :template => 'pages/show' if @page#'content/show' if @page
      end      
      
      # Returns post.title for use in the <title> element. 
      def title_with_cms_post_check
        return "#{@post.title} - #{Spree::Config[:site_name]}" if @post && !@post.title.blank?
        title_without_cms_post_check
      end
      alias_method_chain :title, :cms_post_check      
      
    end
    
    AppConfiguration.class_eval do
      preference :cms_permalink, :string, :default => 'blog'      
      preference :cms_posts_per_page, :integer, :default => 5
      preference :cms_posts_recent, :integer, :default => 15
      preference :cms_post_comment_default, :integer, :default => 1
      preference :cms_post_status_default, :integer, :default => 0
      preference :cms_page_status_default, :integer, :default => 0
      preference :cms_page_comment_default, :integer, :default => 0
      preference :cms_rss_description, :string, :default => 'description about your main post rss.'
      preference :cms_post_tag_menu, :string, :default => ''
    end  
    
    User.class_eval do
        has_many :posts
        
        attr_accessible :display_name        
    end

    # add tiny_mce WYSIWYG editor for cms_extension
    Admin::ProductsController.class_eval do
      uses_tiny_mce :only => [:new, :create, :edit, :update, :index], :options => {
        :editor_selector                 => 'fullwidth mceEditor',
        :theme                           => 'advanced',
        :theme_advanced_toolbar_location => 'top',
        :theme_advanced_toolbar_align    => 'left',
        :theme_advanced_buttons1         => 'bold,italic,underline,justifyleft,justifycenter,justifyright,justifyfull,separator,fontselect,fontsizeselect,forecolor,backcolor',
        :theme_advanced_buttons2         => 'pasteword,separator,search,replace,separator,bullist,numlist,outdent,indent,blockquote,separator,undo,redo,separator,link,unlink,anchor,image,media,code,separator,preview',
        :theme_advanced_buttons3         => 'tablecontrols,separator,hr,separator,sub,sup,separator,print',
        :plugins                         => %w{ table fullscreen paste searchreplace advlink advimage preview  print }
      }
    end
    
    
  end
end
