class BoostsController < ApplicationController

  def create	  
    @boost = Boost.new(:commentary_id => params[:commentaries_id])
    @boost.user = current_user
    
    if @boost.save
      flash[:notice] = "Commentary Boosted!"
      redirect_to commentaries_path
    else
      flash[:error] = "Error when boosting"
      redirect_to commentaries_path
    end
  end
  
  def show
    redirect_to commentary_path(Boost.find(params[:id]).commentary_id)
  end
  
  def destroy
    @boost = Boost.find_by_user_id_and_commentary_id(current_user.id, params[:id])
    @boost.destroy
    flash[:notice] = "Your Boost has been destroyed!"
    redirect_to commentaries_path
  end
  
end
