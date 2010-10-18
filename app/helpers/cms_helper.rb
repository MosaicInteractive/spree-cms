module CmsHelper 
  # RAILS 3 TODO - no longer needed
  def button_link_to_remote(text, url, html_options = {})
    html_options.reverse_merge! :remote => true
    link_to(text_for_button_link(text, html_options), url, html_options_for_button_link(html_options))
  end

  # def link_to_remote(name, options = {}, html_options = {})
  #   options[:before] ||= "jQuery(this).parent().hide(); jQuery('#busy_indicator').show();"
  #   options[:complete] ||= "jQuery('#busy_indicator').hide()"
  #   link_to_function(name, remote_function(options), html_options || options.delete(:html))
  # end
 
  def linked_tag_list(tags)
    tags.collect {|tag| link_to(tag.name, tag_posts_url(:tag_name => tag.name ))}.join(", ")
  end
  
  def post_link_list(limit = Spree::Config[:cms_posts_recent])
    link = Struct.new(:name,:url)
    Post.publish.find(:all, :limit => limit).collect { |post| link.new(post.title, post_path(post)) }
  end
  
  def page_link(id)
    if id.kind_of?(String)  
      page = Page.publish.find_by_permalink(id)
    elsif id.kind_of?(Fixnum)
      page = Page.publish.find(id)
    end
    link_to page.title, page.link unless page.nil?
  end
  
end 
