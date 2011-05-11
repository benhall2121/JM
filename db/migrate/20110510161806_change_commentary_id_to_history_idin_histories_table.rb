class ChangeCommentaryIdToHistoryIdinHistoriesTable < ActiveRecord::Migration
  def self.up
    rename_column :histories, :commentary_id, :history_id
  end

  def self.down
  	  rename_column :histories, :history_id, :commentary_id
  end
end
