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
