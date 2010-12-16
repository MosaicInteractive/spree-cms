class PagesController < Spree::BaseController  
  uses_tiny_mce :only => [:new, :index]

  resource_controller
  actions :show, :index
end 
