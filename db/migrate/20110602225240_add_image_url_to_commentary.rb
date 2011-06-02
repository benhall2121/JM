class AddImageUrlToCommentary < ActiveRecord::Migration
  def self.up
    add_column :commentaries, :image_url, :string
  end

  def self.down
    remove_column :commentaries, :image_url
  end
end
