Rails.application.routes.draw do
  resources :posts#, :as => Spree::Config[:cms_permalink]
  match "#{Spree::Config[:cms_permalink]}/tags/:tag_name" => "posts#tags", :as => "tag_posts"
  resources :pages
  namespace :admin do
    resource :cms_settings
    resources :posts
    resources :pages
    resources :post, :only => [:index, :new, :create]
  end
end
