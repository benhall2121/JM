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
  	conditions = ["id NOT in (?)", boost]
      elsif !params[:user_id].nil? && !params[:pending]
  	#Commentaries for the current user that have been boosted
  	conditions =  ["user_id=(?) AND id in (?)", current_user, boost]
      elsif !params[:user_id].nil? && params[:pending]
  	#Commentaries for the current user that have NOT been boosted
  	conditions = ["user_id=(?) AND id NOT in (?)", current_user, boost]
      else
        conditions = ["id in (?)", boost]
      end
    @commentaries = Commentary.find(:all, :conditions => conditions, :order => 'created_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @commentaries }
    end
  end

  # GET /commentaries/1
  # GET /commentaries/1.xml
  def show
  	  puts "commentary show"
    if params[:unique_id]
      strs = params[:unique_id]
      @quesy_hash={}
      
      for str in strs.split("$")
	s= str.split("=")
	@quesy_hash[s[0]]= s[1]
      end
      
      v = @quesy_hash['v'] # v is the version. If the conversion of for the url ever changes, change v so that any old url's using version 1 will still work
      com = @quesy_hash['com'] # com is the commentary_id. com = 2 to the power of the original commentary_id. The inverse of this is log(@quesy_hash['com'])/log(2)
      cu = @quesy_hash['cu'] # cu is the current_user_id. The current_user_id is the user who shared the commentary. cu = 3 to the power of the original current_user_id. The inverse of this is log(@quesy_hash['cu'])/log(3)
      coming_from = request.env['HTTP_REFERER']
      
      commentary_id = Math::log(com).div(Math::log(2))
      user_shared = Math::log(cu).div(Math::log(3))
      
      #Check to make sure the site isn't just being refreshed and is coming from another site
      if((request.env['REMOTE_HOST'] && request.env['REMOTE_HOST'] != request.domain) && (!current_user || current_user.id != user_shared) && (Time.current > History.find_by_history_type_and_history_id_and_user_id('Share Commentary', commentary_id, user_shared).created_at + 10.seconds))
       History.create_history(:history_id => commentary_id, :user_id => user_shared, :history_type => 'Shared Commentary Link', :datetime => Time.current, :ipaddress => request.env['REMOTE_ADDR'], :HttpReferrer => request.env['HTTP_REFERER'] )
      end
      
      params[:id] = commentary_id
    end
    @commentary = Commentary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @commentary }
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

  # GET /commentaries/1/edit
  def edit
    @commentary = Commentary.find(params[:id])
  end

  # POST /commentaries
  # POST /commentaries.xml
  def create
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

  # PUT /commentaries/1
  # PUT /commentaries/1.xml
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

  # DELETE /commentaries/1
  # DELETE /commentaries/1.xml
  def destroy
    @commentary = Commentary.find(params[:id])
    @commentary.destroy

    respond_to do |format|
      format.html { redirect_to(commentaries_url) }
      format.xml  { head :ok }
    end
  end
  
  def share_commentary
    if !History.find_by_history_type_and_history_id_and_user_id('Share Commentary', params[:commentary_id], current_user.id)	  
      History.create_history(:history_id => params[:commentary_id], :user_id => current_user.id, :history_type => 'Share Commentary', :datetime => Time.current )
    end
    render :nothing => true  
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
    
    link_update = Hash.new
    link_update = {:site_title => title, :site_desc => desc, :site_images => site_images, :site_link => url}
    
    respond_to do |format|
      format.js { render(:partial => "shared/get_link_info", :locals => {:u => link_update})}
    end
    
   end
   
  def handle_images(root, images)
    if !images.nil?
    
    completed_urls = ""
    src = ""
    
      images.each { |i|
        slash=""
        # Make sure all single quotes are replaced with double quotes.
        # Since we aren't rendering javascript we don't really care
        # if this breaks something.
        i.gsub!("'", "\"")   
        # Grab everything between src=" and ".
        src = i.scan(/src=[\"\']([^\"\']+)/).to_s
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
          completed_urls = completed_urls + "," + src
        end
      }

        return completed_urls  
    end
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
