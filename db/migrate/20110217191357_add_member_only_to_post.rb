class AddMemberOnlyToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :members_only, :integer, :default => 0
  end

  def self.down
    remove_column :posts, :members_only
  end
end
