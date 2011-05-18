class History < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentary, :class_name => "Create Commentary", :foreign_key => 'commentary_id'
  belongs_to :boost, :class_name => "Boost Commentary", :foreign_key => 'boost_id'
  
  def self.create_history(params)
  	  puts 'in create history'
    history = History.find_by_history_type_and_history_id_and_user_id(params[:history_type], params[:history_id], params[:user_id])
    if history && params[:history_type] != 'Poll Taken' && params[:history_type] != 'Shared Commentary Link'
      history.datetime = params[:datetime]
      history.save!
    elsif params[:history_type] == 'Shared Commentary Link'
    	    puts 'in shared commentary link'
    	shared_history = History.find_by_history_type_and_history_id_and_user_id_and_ipaddress_and_HttpReferrer(params[:history_type], params[:history_id], params[:user_id], params[:ipaddress], params[:HttpReferrer], :order => 'created_at desc')
    	
    	if shared_history &&  params[:datetime] < (shared_history.created_at + 5.minutes)
    	  shared_history.save!
  	else
  	  History.new(params).save!  
    	end	
    else
      History.new(params).save!
    end
  end
end
