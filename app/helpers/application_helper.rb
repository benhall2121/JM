module ApplicationHelper
  
  def title(page_title)
    content_for(:title) { page_title }
  end	
	
  def commentary_created_today
    if History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND created_at > (?)', current_user.id, 'Create Commentary', (Date.today-1.day).to_s + ' 23:59:59'], :order => "created_at DESC")
      return true
    else
      return false
    end
  end
  
  def boost_commentary_today
    if History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND created_at > (?)', current_user.id, 'Boost Commentary', (Date.today-1.day).to_s + ' 23:59:59'], :order => "created_at DESC")
      return true
    else
      return false
    end
  end  
  
  def share_commentary_today
  	  if History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND created_at > (?)', current_user.id, 'Share Commentary', (Date.today-1.day).to_s + ' 23:59:59'], :order => "created_at DESC")
      return true
    else
      return false
    end
  end  
  
  def shared_commentary_count_today
    history = History.find(:first, :conditions => ['user_id = (?) AND history_type = (?)', current_user.id, 'Share Commentary'], :order => 'created_at desc') 
    return history.created_at.to_date >= Date.today
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
    user_level_count = 1	  
    # Level 1
    if milestone_complete_your_first_challenge && milestone_achieved_first_page_view && milestone_achieved_10th_page_view && milestone_achieved_100th_page_view
     user_level_count = 2    
    end
  	  
    # Level 2
    if user_level_count == 2 
    	    puts "user testing for level 2" 
      user_level_count = 3  
    end
    
    return user_level_count
  end
  
  def rank_of_user
    users = User.find(:all).count
    ul_pv = History.find_by_sql(["select * from (select user_id, count(*) as level, 0 as pageViews from histories where history_type='Milestone' group by user_id UNION select user_id, 0 as level, count(*) as pageViews from histories where history_type='Shared Commentary Link' group by user_id) as s group by user_id order by level desc, pageViews desc;"])
    
    i = 1
    rank = 0
    ul_pv.each do |ulpv|
      if "#{ulpv['user_id']}" == current_user.id.to_s	    
      	      rank = i
      	      p = true
      	      break
      end
      i += 1
    end
    
    rank_percentile = (((users-rank).to_f/users).to_f)*100  
    
    return rank_percentile.to_i.to_s + '%'  
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
    if History.find(:all, :conditions => ['user_id = (?) AND history_type = (?) AND milestone_type = (?)', current_user.id, 'Milestone', 'Complete your first Challenge'])
     return true
    else
     return false
    end
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
    ccc = share_commentary_today	  
  	  
    if (ccc && !History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND milestone_type = (?)', current_user.id, 'Milestone', 'Complete your first Challenge']))  
      History.create_history(:user_id => current_user.id, :history_type => 'Milestone', :datetime => Time.current, :milestone_type => 'Complete your first Challenge')	    
    end		  
    	  
    return ccc
  end
  
  def logged_in?
    !!current_user
  end
  
  def is_admin?
    return current_user.admin?	  
  end
  
  def last_commentary_shared
    return History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND created_at > (?)', current_user.id, 'Share Commentary', (Date.today-1.day).to_s + ' 23:59:59'], :order => "created_at DESC")	
  end
	
end
