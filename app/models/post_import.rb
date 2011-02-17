# This model is the master routine for uploading posts
# Requires Paperclip and FasterCSV to upload the CSV file and read it nicely.

# Author:: Josh McArthur
# License:: MIT

class PostImport < ActiveRecord::Base
  has_attached_file :data_file, :path => ":rails_root/lib/etc/post_data/data-files/:basename.:extension"
  validates_attachment_presence :data_file
  
  require 'fastercsv'
  require 'pp'
  require 'htmlentities'
  
  ## Data Importing:
  # Model maps to post title, excerpt, body, and tags
  
  def import_data
    begin
      #Get posts *before* import - 
      @posts_before_import = Post.all

      #Setup HTML decoder
      coder = HTMLEntities.new

      default_user = 4
      columns = ImportPostSettings::COLUMN_MAPPINGS
      rows = FasterCSV.read(self.data_file.path)
      log("Importing posts for #{self.data_file_file_name} began at #{Time.now}")
      nameless_post_count = 0

      rows[ImportPostSettings::INITIAL_ROWS_TO_SKIP..-1].each do |row|

        #Create the post skeleton - should be valid
        post_obj = Post.new()

        #Set default user
        post_obj.user_id = default_user
        
        #Easy ones first
        if row[columns['Title']].blank?
          log("Post with no title: #{row[columns['Body']]}")
          post_obj.title = "No-name post #{nameless_post_count}"
          nameless_post_count += 1
        else
          #Decode HTML for names and/or descriptions if necessary
          if ImportPostSettings::HTML_DECODE_TITLES
            post_obj.title = coder.decode(row[columns['Title']])
          else
            post_obj.title = row[columns['Title']]
          end
        end
        post_obj.created_at = row[columns['Create Date']] || DateTime.now
        post_obj.published_at = row[columns['Create Date']] || DateTime.now
        post_obj.updated_at = row[columns['Update Date']] || DateTime.now
        post_obj.is_active = 1
        #Decode HTML for descriptions if needed
        if ImportPostSettings::HTML_DECODE_POST_BODY
          post_obj.excerpt = coder.decode(row[columns['Excerpt']])
          post_obj.body_raw = coder.decode(row[columns['Body']])
        else
          post_obj.excerpt = row[columns['Excerpt']]
          post_obj.body_raw = row[columns['Body']]
        end
        post_tags = row[columns['Tags']].downcase || ""
        if not row[columns['Keywords']].blank?
          post_tags = "," if not post_tags.blank?
          post_tags = "#{post_tags}#{row[columns['Keywords']].downcase}"
        end
        post_obj.tag_list = post_tags
        #post_obj.meta_description = row[columns['Meta Description']] || ''
        #post_obj.meta_keywords = row[columns['Meta Keyword']] || ''
        
        unless post_obj.valid?
          log("A post could not be imported - here is the information we have:\n #{ pp post_obj.attributes}", :error)
          next
        end
        
        #Return a success message
        log("#{post_obj.title} successfully imported.\n") if post_obj.save
      end
      
      if ImportPostSettings::DESTROY_ORIGINAL_POSTS_AFTER_IMPORT
        @posts_before_import.each { |p| p.destroy }
      end
      
      log("Importing posts for #{self.data_file_file_name} completed at #{DateTime.now}")
      
    rescue Exception => exp
      log("An error occurred during import, please check file and try again. (#{exp.message})\n#{exp.backtrace.join('\n')}", :error)
      return [:error, "The file data could not be imported. Please check that the spreadsheet is a CSV file, and is correctly formatted."]
    end
    
    #All done!
    return [:notice, "Post data was successfully imported."]
  end
  
  
  private 
  
  ### MISC HELPERS ####
  
  #Log a message to a file - logs in standard Rails format to logfile set up in the import_posts initializer
  #and console.
  #Message is string, severity symbol - either :info, :warn or :error
  
  def log(message, severity = :info)   
    @rake_log ||= ActiveSupport::BufferedLogger.new(ImportPostSettings::LOGFILE)
    message = "[#{Time.now.to_s(:db)}] [#{severity.to_s.capitalize}] #{message}\n"
    @rake_log.send severity, message
    puts message
  end
  
end
