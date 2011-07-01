require 'disqus'
require 'htmlentities'
require 'is_taggable'
require 'rails'
require 'RedCloth'
require 'spree_core'
require 'spree_cms_hooks'

module SpreeCms
  class Engine < Rails::Engine
    initializer "cms" do
      require 'extensions/string'
    end
    
    initializer 'load_disqus_config' do
      if File.exists?("#{Rails.root}/config/disqus_config.yml")
        raw_config = File.read("#{Rails.root}/config/disqus_config.yml")
        DISQUS_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys
      else
        DISQUS_CONFIG = {}
      end
    end
    
	  def self.activate
	    
	    ::Disqus::defaults[:account] = DISQUS_CONFIG[:account]
      # Optional, only if you're using the API
      ::Disqus::defaults[:api_key] = DISQUS_CONFIG[:api_key]
      ::Disqus::defaults[:developer] = DISQUS_CONFIG[:developer]
      
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
        preference :cms_post_tag_menu, :string, :default => ''
        preference :cms_disqus_account
        preference :cms_disqus_api_key
        preference :cms_disqus_developer
      end  
      
      User.class_eval do
          has_many :posts
          
          attr_accessible :display_name        
      end
      
      
      ::Ability.register_ability(::CmsAbilityDecorator)
    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare &method(:activate).to_proc
  end
end
