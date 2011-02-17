class Admin::PostImportController < Admin::BaseController
  
  #Sorry for not using resource_controller railsdog - I wanted to, but then... I did it this way.
  #Verbosity is nice?
  #Feel free to refactor and submit a pull request.
  
  def index
    redirect_to :action => :new
  end
  
  def new
    @post_import = PostImport.new
  end
  
  
  def create
    @post_import = PostImport.create(params[:post_import])
    #import_data returns an array with two elements - a symbol (notice or error), and a message
    import_results = @post_import.import_data
    flash[import_results[0]] = import_results[1]
    render :new
  end
end
