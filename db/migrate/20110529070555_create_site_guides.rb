class CreateSiteGuides < ActiveRecord::Migration
  def self.up
    create_table :site_guides do |t|
      t.string :question
      t.string :answer

      t.timestamps
    end
  end

  def self.down
    drop_table :site_guides
  end
end
