module CmsHelper 
  require 'htmlentities'
  
  def linked_tag_list(tags)
    tags.collect {|tag| link_to(tag.name, tag_posts_url(:tag_name => tag.name ))}.join(", ")
  end

  def linked_tag_menu_list
    tag_menu_link = Struct.new(:name, :url)
    tags = Spree::Config[:cms_post_tag_menu]
    tags = tags.split(',') if not tags.blank?
    tags.collect { |tag| tag_menu_link.new(tag.downcase.titleize, "/blog/tags/#{tag}") }
  end
  
  def post_link_list(limit = Spree::Config[:cms_posts_recent])
    link = Struct.new(:name,:url, :post_published_at, :post_updated_at, :post_description)
    Post.publish.limit(limit).collect { |post| link.new(post.title, post_path(post), post.published_at, post.updated_at, post.excerpt) }
  end

  def latest_post
    Post.find(:last, :order => 'updated_at DESC')
  end
  
  def page_link(id)
    if id.kind_of?(String)  
      page = Page.publish.find_by_permalink(id)
    elsif id.kind_of?(Fixnum)
      page = Page.publish.find(id)
    end
    link_to page.title, page.link unless page.nil?
  end

  def html_entities(str)
    coder = HTMLEntities.new
    coder.decode(str) 
  end
  
end 
