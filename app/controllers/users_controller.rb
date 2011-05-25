class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index 
    if current_user
      redirect_to :action => 'show', :id => current_user.id
    else
    @user_session = UserSession.new
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    #boost = Boost.where("user_id=(?)", current_user).map(&:commentary_id)
    boost = Boost.find(:all, :order => 'created_at desc').map(&:commentary_id)
    @commentaries = Commentary.find(:all, :limit => 10, :conditions => ["id in (?)", boost], :order => 'created_at desc')

    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    if current_user	 
      redirect_to user_path(current_user)	    
      return
    end	   
    @user_session = UserSession.new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
      	format.html { redirect_to(@user, :notice => 'Registration successfull.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def poll_taken
  #If the poll section is built out this should be moved to that controller
  if !History.find(:first, :conditions => ['user_id = (?) AND history_type = (?) AND datetime > (?)', current_user.id, 'Poll Taken', (Date.today-1.day).to_s + ' 23:59:59'], :order => "datetime DESC")
    answer = params[:poll_id].delete "Option "
    History.create_history(:user_id => current_user.id, :history_id => answer.to_i, :history_type => 'Poll Taken', :datetime => Time.now )
  end 
    render :nothing => true
  end
end
