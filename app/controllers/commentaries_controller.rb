require 'net/http'
require 'uri'

class CommentariesController < ApplicationController
  #	before_filter :require_user, :only => [:new, :edit]
	
  # GET /commentaries
  # GET /commentaries.xml
  def index
    @commentaries = Commentary.all(:order => 'created_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @commentaries }
    end
  end
  
  def shareable
  	
   boost = Boost.find(:all).map(&:commentary_id)

      if params[:boost] && current_user.admin?
   	#Commentaries that have NOT been boosted
   	if boost.blank?
   	 conditions = ["id IS NOT NULL"]	
   	else
  	 conditions = ["id NOT in (?)", boost]
        end
      elsif !params[:user_id].nil? && !params[:pending]
  	#Commentaries for the current user that have been boosted
  	 conditions =  ["user_id=(?) AND id in (?)", current_user, boost]
      elsif !params[:user_id].nil? && params[:pending]
  	#Commentaries for the current user that have NOT been boosted
  	if boost.blank?
  	 conditions = ["user_id=(?) AND id IS NOT NULL", current_user]
	else
  	 conditions = ["user_id=(?) AND id NOT in (?)", current_user, boost]
	end
      else
      	# Only boosted commentaries for the front page
        conditions = ["id in (?)", boost]
        limit = 30
      end
    @commentaries = Commentary.find(:all, :limit => limit || 50000, :conditions => conditions, :order => 'created_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @commentaries }
      format.js { }
    end
  end

  # GET /commentaries/1
  # GET /commentaries/1.xml
  def show
    if params[:unique_id]
      strs = params[:unique_id]
      @quesy_hash={}
      
      for str in strs.split("$")
	s= str.split("!!")
	@quesy_hash[s[0]]= s[1]
      end
      
      v = @quesy_hash['v'] # v is the version. If the conversion of for the url ever changes, change v so that any old url's using version 1 will still work
      com = @quesy_hash['com'] # com is the commentary_id. com = 2 to the power of the original commentary_id. The inverse of this is log(@quesy_hash['com'])/log(2)
      cu = @quesy_hash['cu'] # cu is the current_user_id. The current_user_id is the user who shared the commentary. cu = 3 to the power of the original current_user_id. The inverse of this is log(@quesy_hash['cu'])/log(3)
      coming_from = request.env['HTTP_REFERER']
      coming_from_ip_address = request.env['REMOTE_ADDR']
      
      commentary_id = Math::log(com).div(Math::log(2))
      user_shared = Math::log(cu).div(Math::log(3))
      
      @user_session = UserSession.new if @user_session.nil?
      
      #Is it a bot checking the link
      am_i_robot = ["googlebot","twitterbot", "facebookexternalhit", "google.com/bot.html", "facebook.com/externalhit_uatext.php", "tweetmemebot", "sitebot", "msnbot", "robot", "bot", "facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)"]
      bot_checking_link = am_i_robot.include?(request.env["HTTP_USER_AGENT"])
      
      #Check to make sure the site isn't just being refreshed and is coming from another site
      if((request.env['REMOTE_HOST'] != request.domain && request.env['REMOTE_HOST'] != request.domain) && (!current_user || current_user.id != user_shared) && !bot_checking_link)
       History.create_history(:history_id => commentary_id, :user_id => user_shared, :history_type => 'Shared Commentary Link', :datetime => Time.now, :ipaddress => coming_from_ip_address, :HttpReferrer => coming_from )
      end
      
      params[:id] = commentary_id
    end
    @commentary = Commentary.find(params[:id])

   if params[:unique_id] && @commentary.links && !bot_checking_link
     redirect_to(@commentary.links)
   else 
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @commentary }
    end
   end
  end
  
  # GET /commentaries/new
  # GET /commentaries/new.xml
  def new
    @commentary = Commentary.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @commentary }
    end
  end

  def edit
    @commentary = Commentary.find(params[:id])
  end

  def create
    # White spaces were causing the facebook and twitter share links to not work	  
    params[:commentary][:title].strip!
    
    if !Commentary.find_by_links(params[:commentary][:links])
     @commentary = Commentary.new(params[:commentary])
     @commentary.user = current_user
     @commentary.save
     @saved = true
    else
      @commentary = Commentary.find_by_links(params[:commentary][:links])    
      @saved = false 	    
    end

    respond_to do |format|
     if @saved
        format.html { redirect_to(@commentary, :notice => 'Commentary was successfully created.') }
        format.xml  { render :xml => @commentary, :status => :created, :location => @commentary }
        format.js { render(:partial => "shared/commentary_link", :locals => {:u => @commentary} )}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @commentary.errors, :status => :unprocessable_entity }
        format.js { render(:partial => "shared/not_saved_commentary_link", :locals => {:u => @commentary} )}
      end
    end
  end

  def update
    @commentary = Commentary.find(params[:id])

    respond_to do |format|
      if @commentary.update_attributes(params[:commentary])
        format.html { redirect_to(@commentary, :notice => 'Commentary was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @commentary.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update_fb
    @commentary = Commentary.find(params[:id])
  
    @commentary.update_attributes(:title => params[:title])
    
    respond_to do |format|
        format.js { render :nothing => true }
    end
  end

  # DELETE /commentaries/1
  # DELETE /commentaries/1.xml
  def destroy
    @commentary = Commentary.find(params[:id])
    commentary_id = params[:id]
    @commentary.destroy

    respond_to do |format|
      format.html { redirect_to(commentaries_url) }
      format.xml  { head :ok }
      format.js   { render "commentaries/boost.js.erb", :locals => {:u => commentary_id} } 
    end
  end
  
  def share_commentary
    share_h = History.find_by_history_type_and_history_id_and_user_id('Share Commentary', params[:commentary_id], current_user.id)
    if !share_h	 
      History.create_history(:history_id => params[:commentary_id], :user_id => current_user.id, :history_type => 'Share Commentary', :datetime => Time.now, :milestone_type => params[:where_to] )
      mt = params[:where_to]
    elsif share_h && share_h.milestone_type != 'facebook / twitter' && share_h.milestone_type != params[:where_to]
      share_h.update_attributes(:milestone_type => 'facebook / twitter')
    end
    mt = share_h.milestone_type if mt.nil?
    
    respond_to do |format|
    	    format.js { render "commentaries/update_share_icons", :locals => {:u => mt.to_s, :commentary_id => params[:commentary_id].to_s, :commentary_title => params[:commentary_title].to_s } }
    end
  end
  
  
  
  
  def get_link_info
     url = params[:link_address]
    return if url.nil? || url.empty?
    
    if !(url[0,7] == "http://" || url[0,8] == "https://")
      if url[0,4] != "www."
        url = "http://www." + url
      else
        url = "http://" + url
      end
    end
    
    resp = Net::HTTP.get_response(URI.parse(url))
    resp_text = resp.body

    title = resp_text.scan(/<title>\s*(.*.\s*.*)\s*<\/title>/i).to_s
    desc = resp_text.scan(/<meta name=\"description\" content=\"\s*(.*)\s*\"/i).to_s
    images = resp_text.scan(/<img [^>]*>/i)
    
    root = parse_page_root(url)
    site_images = handle_images(root, images)
    
    puts "site_images :: #{site_images}"

    title = url if title.blank?
    
    link_update = Hash.new
    link_update = {:site_title => remove_extra_characters_from_string(title), :site_desc => desc, :site_images => site_images, :site_link => url}
    
    respond_to do |format|
      format.js { render(:partial => "shared/get_link_info", :locals => {:u => link_update})}
    end
    
   end
   
  def handle_images(root, images)
    if !images.nil?
    
    completed_urls = ""
    src = ""
    
      images.each { |i|
        puts "i :: #{i}"

        slash=""
        # Make sure all single quotes are replaced with double quotes.
        # Since we aren't rendering javascript we don't really care
        # if this breaks something.
        i.gsub!("'", "\"")   
        # Grab everything between src=" and ".
        src = i.scan(/src=[\"\']([^\"\']+)/).to_s

        src = remove_extra_characters_from_string(src)

        #if the src has two // do not use the image. YouTube has // for a lot of little gifs
        if src[0,2] == "//" || src[0,2] == "__"
          next
        end
        
        # If the src is empty move on.
        next if src.nil? || src.empty?
        
        # If we don't have an absolute path already, let's make one.     
        if !root.nil? && src[0,4] != "http"
          if src[0,1] != "/"
            slash = "/"
          end
          src = root + slash + src
        end

        if completed_urls == ""
         completed_urls = src
 	else
 		# We want pngs if any
 		#Compare the two if they are both png's or of neither are pngs
 		if (completed_urls.match(/.png/i) && src.match(/.png/i)) || (!completed_urls.match(/.png/i) && !src.match(/.png/i))
			if completed_urls.size < src.size
				completed_urls = src	
			end
		elsif (!completed_urls.match(/.png/i) && src.match(/.png/i)) 
			completed_urls = src
		end	
 	end
        
       #Use this if doing an image picker
       if completed_urls == ""
         completed_urls = src
       else
         completed_urls = completed_urls + "," + src
       end
      }

        return completed_urls  
    end
  end

  def remove_extra_characters_from_string(theString)
    puts "theString :: #{theString}"
    theString.gsub!(/\[/i, "").gsub!(/\]/i, "").gsub!(/\"/i, "")  
  end
  
  def parse_page_root(url)
    end_slash = url.rindex("/")
    if end_slash > 8
      url[0, url.rindex("/")]
    else
      url
    end
  end
  
  
end
