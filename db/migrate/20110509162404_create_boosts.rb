class CreateBoosts < ActiveRecord::Migration
  def self.up
    create_table :boosts do |t|
      t.integer :user_id
      t.integer :commentary_id

      t.timestamps
    end
  end

  def self.down
    drop_table :boosts
  end
end
