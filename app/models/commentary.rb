class Commentary < ActiveRecord::Base
  belongs_to :user
  belongs_to :history
  
  has_many :boosts, :dependent => :destroy
  
  after_create  :add_history
  after_destroy :remove_history
  
  def add_history
    History.create_history(:history_id => self.id, :user_id => self.user_id, :history_type => 'Create Commentary', :datetime => self.created_at)
  end
  
  def remove_history
    History.find_by_history_type_and_history_id('Create Commentary', self.id).destroy
  end
end
