class AddStateYouVoteInToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :state_you_vote_in, :string
  end

  def self.down
    remove_column :users, :state_you_vote_in
  end
end
