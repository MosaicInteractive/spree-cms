require 'disqus'
require 'spree_core'
require 'spree_cms_hooks'

module SpreeCms
  class Engine < Rails::Engine
  def self.activate
    Disqus::defaults[:account] = "my_disqus_account_name"
    # Optional, only if you're using the API
    Disqus::defaults[:api_key] = "my_disqus_api_key"    
    unless Rails.env == "production"
      Disqus::defaults[:developer] = true
    end

    Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
      Rails.env == "production" ? require(c) : load(c)
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
    end  
    
    User.class_eval do
	has_many :posts
	
	attr_accessible :display_name        
    end
  end

    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare &method(:activate).to_proc
  end
end
