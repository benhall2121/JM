module ApplicationHelper
	
  def taken_todays_poll  
  	  
    if History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND datetime > (?)', current_user.id, 'Poll Taken', Time.now-1.day])
      return true
    else
      return false
    end
  end
  
  def commentary_created_today
    if History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND datetime > (?)', current_user.id, 'Create Commentary', Time.now-1.day])
      return true
    else
      return false
    end
  end
  
  def boost_commentary_today
    if History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND datetime > (?)', current_user.id, 'Boost Commentary', Time.now-1.day])
      return true
    else
      return false
    end
  end  
  
  def share_commentary_today
    if History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND datetime > (?)', current_user.id, 'Share Commentary', Time.now-1.day])
      return true
    else
      return false
    end
  end  
	
end
