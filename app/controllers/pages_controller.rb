class PagesController < Spree::BaseController  
  skip_before_filter :check_authorization
  resource_controller
  actions :show, :index
end 
