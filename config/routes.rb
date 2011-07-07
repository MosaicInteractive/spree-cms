Rails.application.routes.draw do
  resources :posts, :only => [:show, :index], :path => "#{Spree::Config[:cms_permalink]}", :as => "posts"

  match "/#{Spree::Config[:cms_permalink]}/tags/:tag_name" => 'posts#tags', :as => :tag_posts

  resources :pages

  namespace :admin do
    resource :cms_settings
    resources :posts, :only => [:index, :new, :create]
    resources :pages
  end
end
