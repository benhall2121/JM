class BoostsController < ApplicationController

  def create	  
    @boost = Boost.new(:commentary_id => params[:commentaries_id])
    @boost.user = current_user
    boost_id = @boost.commentary_id
    
    if @boost.save
      flash[:notice] = "Commentary Boosted!"
      puts "yeah"
      respond_to do |format|
      	format.html { redirect_to commentaries_path }
      	format.js {render "commentaries/boost.js.erb", :locals => {:u => boost_id.to_s}} 
      end
    else
      flash[:error] = "Error when boosting"
      redirect_to commentaries_path
    end
  end
  
  def show
    redirect_to commentary_path(Boost.find(params[:id]).commentary_id)
  end
  
  def destroy
    @boost = Boost.find_by_commentary_id(params[:commentaries_id])
    boost_id = params[:commentaries_id]
    @boost.destroy
    flash[:notice] = "Your Boost has been destroyed!"
    respond_to do |format|
      format.js { render "commentaries/boost", :locals => {:u => boost_id} }    
    end
  end
  
end
