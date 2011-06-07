class ChangeDataTypeForAboutsBody < ActiveRecord::Migration
  def self.up
    change_table :abouts do |t|
    	    t.change :body, :text
    end
  end

  def self.down
    change_table :abouts do |t|
    	    t.change :body, :string
    end
  end
end
