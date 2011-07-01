Rails.application.routes.draw do
  resources :posts #, :as => Spree::Config[:cms_permalink]

  match "#{Spree::Config[:cms_permalink]}/tags/:tag_name", :to => 'posts#tags'

  resources :pages

  namespace :admin do
    resource :cms_settings
    resources :posts, :only => [:index, :new, :create]
    resources :pages
  end
end
