class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :commentaries
  has_many :boosts, :dependent => :destroy
  
  has_many :histories, :dependent => :destroy
  has_many :commentaries, :through => :histories, :source => :commentary, :conditions => "histories.history_type = 'Create Commentary'"
  has_many :boosts, :through => :histories, :source => :boost, :conditions => "histories.history_type = 'Boost Commentary'"
end
