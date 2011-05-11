class AddDatetimeToHistories < ActiveRecord::Migration
  def self.up
    add_column :histories, :datetime, :datetime
  end

  def self.down
    remove_column :histories, :datetime
  end
end
