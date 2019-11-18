class Api::V1::FavoritesController < Api::V1::ApiController
  before_action :authorize_request
  before_action :set_favorited
  
  def create
    if Favorite.create(favorited: @favorited, user: @current_user)
      render json: {succes: true, status: 200}
    else
      render_error("Something went wrong....!", 404)
    end
  end
  
  def destroy
    Favorite.where(favorited: @favorited, user_id: @current_user.id).first.destroy
    render json: {succes: true, status: 200}
  end
  
  private

  def set_favorited
  	if params[:job_id] 
  		@favorited = Job.find_by_id params[:job_id] 
		else
			@favorited = User.find_by_id params[:freelancer_id] 
		end
  end

end
