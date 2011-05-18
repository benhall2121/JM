class HistoriesController < ApplicationController
  def index
  	  @histories = History.find(:all, :conditions => ["user_id = (?)", current_user.id], :order => 'created_at desc')
    if params[:month]
      params[:month] += '-01'
      @date =  Date.parse(params[:month])   
    else
      @date = Date.today   
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @histories }
    end
  end
  
  def show
    @history = History.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @history }
    end	
  end
  
end
