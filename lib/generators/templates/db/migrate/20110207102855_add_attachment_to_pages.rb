class AddAttachmentToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, "attachment_content_type", :string
    add_column :pages, "attachment_file_name",    :string
    add_column :pages, "attachment_size",         :integer
    add_column :pages, "type",                    :string, :limit => 75
    add_column :pages, "attachment_updated_at",   :datetime
    add_column :pages, "attachment_width",        :integer
    add_column :pages, "attachment_height",       :integer
  end

  def self.down
    remove_column :pages, "attachment_content_type"
    remove_column :pages, "attachment_file_name"
    remove_column :pages, "attachment_size"
    remove_column :pages, "type"
    remove_column :pages, "attachment_updated_at"
    remove_column :pages, "attachment_width"
    remove_column :pages, "attachment_height"
  end
end
