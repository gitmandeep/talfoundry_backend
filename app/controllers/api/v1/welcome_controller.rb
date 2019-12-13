class Api::V1::WelcomeController < Api::V1::ApiController
	def index
    if params[:search_freelancers].present? || params[:search_jobs].present?
      search_by, where_data = create_search_fields
      sorted_data = []

      model = params[:search_freelancers].present? ? User : Job
      search_fields = params[:search_freelancers].present? ? [:user_category] : [:job_category]
      serializer = params[:search_freelancers].present? ? FreelancerSerializer : JobSerializer

      filtered_data = model.search(search_by, where: where_data, fields: search_fields).to_a

      if params[:sort_by].present?
        if filtered_data.present?
          data_to_sort_by = model.where(id: filtered_data.map(&:id))
          sorted_data = data_to_sort_by.send(params[:sort_by].downcase).public_data
        else
          sorted_data = model.send(params[:sort_by].downcase).public_data
        end
      end
      filtered_records = (filtered_data.push(sorted_data)).flatten.uniq.sort_by {|s| s.created_at}.reverse
    elsif params[:find_freelancers].present?
      filtered_records = User.manager_freelancer_index
    elsif params[:find_jobs]
      filtered_records = Job.recent
    end
    if params[:search_freelancers].present? || params[:find_freelancers].present?
    	render json: filtered_records, each_serializer: FreelancerSerializer, include: 'profile', status: :ok
    elsif params[:search_jobs].present? || params[:find_jobs].present?
    	render json: filtered_records, each_serializer: JobSerializer, include: 'job.**', status: :ok
    end
  end

  def show
    model = params[:freelancer].present? ? User : Job
    serializer = params[:freelancer].present? ? FreelancerSerializer : JobSerializer
    show_data =  model.find_by_uuid(params[:id])
    if show_data
      render json: show_data, serializer: serializer, status: :ok
    else
      render_error('Not found', 401)
    end
  end
  
  private
  def create_search_fields
    filters = JSON.parse(params[:search_freelancers] || params[:search_jobs]).symbolize_keys
    filters = filters.reject { |key,value| value.empty? }
    
    if params[:search_freelancers].present? && filters[:location].present?
      if Profile.where(current_location_country: filters[:location]).present?
        filters[:current_country] = filters[:location]
        filters.delete(:location)
      elsif Profile.where(current_location_city: filters[:location]).present?
        filters[:current_city] = filters[:location]
        filters.delete(:location)
      end
    end

    if filters[:category].present?
      search_by = filters[:category]
      filters.delete(:category)
    end

    if params[:search_freelancers].present?
      filters[:account_approved] = true
    else
      filters[:job_visibility] = "Anyone"
    end
    
    where_data = filters

    search_by = where_data.present? ? "*" : "" if search_by.blank?
    return search_by, where_data
  end
end