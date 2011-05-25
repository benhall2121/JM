class AddMilestoneTypeToHistories < ActiveRecord::Migration
  def self.up
    add_column :histories, :milestone_type, :string
  end

  def self.down
    remove_column :histories, :milestone_type
  end
end
