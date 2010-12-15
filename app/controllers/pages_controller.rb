class PagesController < Spree::BaseController  
  uses_tiny_mce :only => [:new]

  resource_controller
  actions :show, :index
end 
