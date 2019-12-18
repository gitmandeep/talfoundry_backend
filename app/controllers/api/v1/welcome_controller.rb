class Api::V1::WelcomeController < Api::V1::ApiController
  def index
    if params[:search_freelancers].present? || params[:search_jobs].present?
      filters = JSON.parse(params[:search_freelancers] || params[:search_jobs]).symbolize_keys
      filters = filters.reject { |key,value| value.empty? }
    end
    if filters.present? || params[:sort_by].present?
      search_by, where_data = create_search_fields(filters)
      sorted_data = []

      model = params[:search_freelancers].present? ? User : Job
      search_fields = params[:search_freelancers].present? ? [:user_category] : [:job_category]
      serializer = params[:search_freelancers].present? ? FreelancerSerializer : JobSerializer

      filtered_data = model.search(search_by, where: where_data, fields: search_fields)
      if params[:search_freelancers].present?
        filtered_data = filtered_data.select{|data| (data.account_approved == true)}
      else
        filtered_data = filtered_data.select{|data| (data.job_visibility == "Anyone")}
      end

      if params[:sort_by].present?
        if filtered_data.present?
          data_to_sort_by = model.where(id: filtered_data.map(&:id))
          sorted_data = data_to_sort_by.send(params[:sort_by].downcase).public_data
        else
          sorted_data = model.send(params[:sort_by].downcase).public_data
        end
        filtered_records = sorted_data.uniq.sort_by {|s| s.created_at}.reverse
      else
        filtered_records = filtered_data.uniq.sort_by {|s| s.created_at}.reverse
      end
      #filtered_records = (filtered_data.push(sorted_data)).flatten.uniq.sort_by {|s| s.created_at}.reverse
    elsif params[:find_freelancers].present?
      filtered_records = User.manager_freelancer_index
    elsif params[:find_jobs]
      filtered_records = Job.recent
    end

    if params[:search].present?
      if params[:search_freelancers].present?
        filtered_records = filtered_records.select{|s| s.first_name.downcase == params[:search].downcase || s.last_name.downcase == params[:search].downcase}
      elsif params[:search_jobs].present? || params[:find_jobs].present?
        filtered_records = filtered_records.select{|s| s.job_title.downcase.include?(params[:search].downcase)}
      end
    end

    if params[:search_freelancers].present? || params[:find_freelancers].present?
      render json: filtered_records, each_serializer: FreelancerSerializer, include: 'profile', status: :ok
    elsif params[:search_jobs].present? || params[:find_jobs].present?
      render json: filtered_records, each_serializer: JobSerializer, include: 'job.**', status: :ok
    end
  end

  def show
    model = params[:freelancer].present? ? Profile : Job
    serializer = params[:freelancer].present? ? ProfileSerializer : JobSerializer
    show_data =  model.find_by_uuid(params[:id])
    if show_data
      render json: show_data, serializer: serializer, status: :ok
    else
      render_error('Not found', 401)
    end
  end

  private
  def create_search_fields(filters)    
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

    if filters[:client_history].present?
      filters.delete(:client_history)
    end
    
    where_data = filters

    search_by = where_data.present? ? "*" : "" if search_by.blank?
    return search_by, where_data
  end
end
