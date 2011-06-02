class History < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentary, :class_name => "Create Commentary", :foreign_key => 'commentary_id'
  belongs_to :boost, :class_name => "Boost Commentary", :foreign_key => 'boost_id'
  
  def self.create_history(params)
    history = History.find_by_history_type_and_history_id_and_user_id(params[:history_type], params[:history_id], params[:user_id])
    if history && params[:history_type] != 'Poll Taken' && params[:history_type] != 'Shared Commentary Link' && params[:history_type] != 'Milestone'
      history.datetime = params[:datetime]
      history.save!
    elsif params[:history_type] == 'Shared Commentary Link'
    	shared_history = History.find_by_history_type_and_history_id_and_user_id_and_ipaddress_and_HttpReferrer(params[:history_type], params[:history_id], params[:user_id], params[:ipaddress], params[:HttpReferrer], :order => 'created_at desc')
    	
    	if shared_history &&  params[:datetime] < (shared_history.created_at + 5.minutes)
    	  shared_history.save!
  	else
  	  History.new(params).save!  
    	end
    elsif params[:history_type] == 'Milestone'
    	milestone_history = History.find_by_history_type_and_user_id_and_milestone_type(params[:history_type], params[:user_id], params[:milestone_type])
    	if !milestone_history
    	  History.new(params).save!
        end
    else
    	    puts Time.now.utc
    	    Time.now.utc
      History.new(params).save!
    end
  end
  
  def group_by_created_at
    if self.created_at.to_date == Date.today	 
      'Today'
    elsif self.created_at.to_date == Date.today-1
      'Yesterday'
    else
      self.created_at.strftime('%A %B %d, %Y')	
    end
  end
  
  def group_by_history_type
    self.history_type
  end
  
  def group_by_history_id
    self.history_id
  end
  
  def group_by_milestone_type
  	  self.milestone_type
  end
end
