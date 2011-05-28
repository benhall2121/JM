module ApplicationHelper
	
  def taken_todays_poll  
    if History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND datetime > (?)', current_user.id, 'Poll Taken', (Date.today-1.day).to_s + ' 23:59:59'], :order => "datetime DESC")
      return true
    else
      return false
    end
  end
  
  def commentary_created_today
    if History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND datetime > (?)', current_user.id, 'Create Commentary', (Date.today-1.day).to_s + ' 23:59:59'], :order => "datetime DESC")
      return true
    else
      return false
    end
  end
  
  def boost_commentary_today
    if History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND datetime > (?)', current_user.id, 'Boost Commentary', (Date.today-1.day).to_s + ' 23:59:59'], :order => "datetime DESC")
      return true
    else
      return false
    end
  end  
  
  def share_commentary_today
    if History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND datetime > (?)', current_user.id, 'Share Commentary', (Date.today-1.day).to_s + ' 23:59:59'], :order => "datetime DESC")
      return true
    else
      return false
    end
  end  
  
  def shared_commentary_count
    return History.find(:all, :conditions => ['user_id = (?) AND history_type = (?)', current_user.id, 'Share Commentary']).count 
  end	

  def shared_commentary_count_one_or_more
    (shared_commentary_count >= 1)? true : false
  end
  
  def shared_commentary_count_x_or_more(x)
    (shared_commentary_count >= x)? true : false
  end
  
  def page_views_count
    return History.find(:all, :conditions => ['user_id = (?) AND history_type = (?)', current_user.id, 'Shared Commentary Link']).count 
  end
  
  def page_views_count_one_or_more
    (page_views_count >= 1)? true : false
  end
  
  def page_views_count_x_or_more(x)
    (page_views_count >= x)? true : false
  end
  	
  def user_level
    return History.find(:all, :conditions => ['user_id = (?) AND history_type = (?)', current_user.id, 'Milestone']).count	  
  end
  
  def rank_of_user
    user_level = History.find(:all, :select => 'user_id, count(*) as level', :conditions => ['history_type = (?)', 'Milestone'], :group => 'user_id', :order => 'level desc' )
    page_views = History.find(:all, :include => @user_level, :select => 'user_id, count(*) as pageViews', :conditions => ['history_type = (?)', 'Shared Commentary Link'], :group => 'user_id', :order => 'pageViews desc' )
    
    return '21'  
  end
  
  
  def milestone_share_first_content
    sc = shared_commentary_count_one_or_more
    #Milestone Share your first content
    if (sc && !History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND milestone_type = (?)', current_user.id, 'Milestone', 'Share your first content']))  
      History.create_history(:user_id => current_user.id, :history_type => 'Milestone', :datetime => Time.current, :milestone_type => 'Share your first content')	    
    end	
    return sc    
  end
  
  def milestone_achieved_first_page_view
    pv = page_views_count_one_or_more
    #Milestone Achieve your first PageView
    if (pv && !History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND milestone_type = (?)', current_user.id, 'Milestone', 'Achieve your first PageView']))  
      History.create_history(:user_id => current_user.id, :history_type => 'Milestone', :datetime => Time.current, :milestone_type => 'Achieve your first PageView')	    
    end	    
    return pv
  end
  
  def milestone_complete_your_first_challenge
  	  return false
  end
  
  def milestone_achieved_10th_page_view
    pv = page_views_count_x_or_more(10)
    #Milestone Achieve your 10th PageView
    if (pv && !History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND milestone_type = (?)', current_user.id, 'Milestone', 'Achieve your tenth PageView']))  
    	    History.create_history(:user_id => current_user.id, :history_type => 'Milestone', :datetime => Time.current, :milestone_type => 'Achieve your tenth PageView')	    
    end	    
    return pv
  end
  
  def milestone_achieved_100th_page_view
    pv = page_views_count_x_or_more(100)
    #Milestone Achieve your 10th PageView
    if (pv && !History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND milestone_type = (?)', current_user.id, 'Milestone', 'Achieve your one hundredth PageView']))  
    	    History.create_history(:user_id => current_user.id, :history_type => 'Milestone', :datetime => Time.current, :milestone_type => 'Achieve your one hundredth PageView')	    
    end	    
    return pv
  end
  
  def current_challenge_complete
  	  return false  
  end
  
  def logged_in?
    !!current_user
  end
  
  def is_admin?
    return current_user.admin?	  
  end
	
end
