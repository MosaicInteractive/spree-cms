# This file is the thing you have to config to match your application

class ImportPostSettings

    #Take a look at the data you need to be importing, and then change this hash accordingly
    #The first column is 0, etc etc.
    #This is accessed in the import method using COLUMN_MAPPINGS['field'] for niceness and readability
    #TODO this could probably be marked up in YML
    COLUMN_MAPPINGS = {
      'Tags' => 0,
      'Create Date' => 1,
      'Title' => 2,
      'Excerpt' => 3,
      'Description' => 4,
      'Keywords' => 5,
      'Body' => 6,
      'Update Date' => 7
    }

    #Where are you keeping your master images?
    #This path is the path that the import code will search for filenames matching those in your CSV file
    #As each post is saved, Spree (Well, paperclip) grabs it, transforms it into a range of sizes and
    #saves the resulting files somewhere else - this is just a repository of originals.
    POST_IMAGE_PATH = "#{Rails.root}/lib/etc/post-data/post-images/"
    
    #From experience, CSV files from clients tend to have a few 'header' rows - count them up if you have them,
    #and enter this number in here - the import script will skip these rows.
    INITIAL_ROWS_TO_SKIP = 1

    #I would just leave this as is - Logging is useful for a batch job like this - so
    # useful in fact, that I have put it in a separate log file.
    LOGFILE = File.join(Rails.root, '/log/', "import_posts_#{Rails.env}.log")
    
    #Set this to true if you want to destroy your existing posts after you have finished importing posts
    DESTROY_ORIGINAL_POSTS_AFTER_IMPORT = true

    #Set default HTML decoding settings
    #If set to true, all names and descriptions will convert
    #&amp; to &, &gt; to >, etc.
    HTML_DECODE_TITLES = false
    HTML_DECODE_POST_BODY = true
end
