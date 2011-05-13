class History < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentary, :class_name => "Create Commentary", :foreign_key => 'commentary_id'
  belongs_to :boost, :class_name => "Boost Commentary", :foreign_key => 'boost_id'
  
  def self.create_history(params)
    history = History.find_by_history_type_and_history_id_and_user_id(params[:history_type], params[:history_id], params[:user_id])
    if history && params[:history_type] != 'Poll Taken'
      history.datetime = params[:datetime]
      history.save!
    else
      History.new(params).save!
    end
  end
end
