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
    boost = Boost.where("user_id=(?)", current_user).map(&:commentary_id)
    @commentaries = Commentary.find(:all, :conditions => ["user_id=(?) OR id in (?)", current_user, boost], :order => 'created_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @commentaries }
    end
  end

  # GET /commentaries/1
  # GET /commentaries/1.xml
  def show
  	  
    if params[:unique_id]
      puts 'in unique 3333222'
      strs = params[:unique_id]
      @quesy_hash={}
      
      for str in strs.split("$")
	s= str.split("=")
	@quesy_hash[s[0]]= s[1]
      end
     
      if current_user
      puts 'current_user'
      puts current_user.id
      end
      
      puts 'aaa'
      
      v = @quesy_hash['v'] # v is the version. If the conversion of for the url ever changes, change v so that any old url's using version 1 will still work
     puts 'bbb'
      com = @quesy_hash['com'] # com is the commentary_id. com = 2 to the power of the original commentary_id. The inverse of this is log(@quesy_hash['com'])/log(2)
      puts 'ccc'
      cu = @quesy_hash['cu'] # cu is the current_user_id. The current_user_id is the user who shared the commentary. cu = 3 to the power of the original current_user_id. The inverse of this is log(@quesy_hash['cu'])/log(3)
      puts 'ddd'
      coming_from = request.env['HTTP_REFERER']
      
      puts '111'
      puts 'com'
      puts com
      puts 'cu'
      puts cu
      puts 'v'
      puts v
      
      commentary_id = Math::log(com).div(Math::log(2))
      
      puts '222'
      
      user_shared = Math::log(cu).div(Math::log(3))
      
      puts '333'
      
      puts 'remote_host'
      puts request.env['REMOTE_HOST']
      puts 'domain'
      puts request.domain
      
      #Check to make sure the site isn't just being refreshed and is coming from another site
      if((request.env['REMOTE_HOST'] && request.env['REMOTE_HOST'] != request.domain) && (!current_user || current_user.id != cu))
      puts 'if to send to history'
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
    @commentary = Commentary.new(params[:commentary])
    @commentary.user = current_user

    respond_to do |format|
      if @commentary.save
        format.html { redirect_to(@commentary, :notice => 'Commentary was successfully created.') }
        format.xml  { render :xml => @commentary, :status => :created, :location => @commentary }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @commentary.errors, :status => :unprocessable_entity }
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
end
