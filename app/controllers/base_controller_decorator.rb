    Spree::BaseController.class_eval do
    # make your helper available in all views
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
	render :template => 'content/show' if @page
      end      
      
      # Returns post.title for use in the <title> element. 
      def title_with_cms_post_check
	return "#{@post.title} - #{Spree::Config[:site_name]}" if @post && !@post.title.blank?
	title_without_cms_post_check
      end
      alias_method_chain :title, :cms_post_check      
      
    end
