class AddIpaddressAndHttpReferrerToHistories < ActiveRecord::Migration
  def self.up
    add_column :histories, :ipaddress, :string
    add_column :histories, :HttpReferrer, :string
  end

  def self.down
    remove_column :histories, :HttpReferrer
    remove_column :histories, :ipaddress
  end
end
