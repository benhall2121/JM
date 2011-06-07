class AddRegistrationCodeInToUsers < ActiveRecord::Migration
  def self.up
  	  add_column :users, :registration_code, :string
  end

  def self.down
    remove_column :users, :registration_code
  end
end
