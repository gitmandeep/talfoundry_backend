class Api::V1::AdminsController < Api::V1::ApiController
  before_action :authorize_request

  def index
    @admins = User.where(role: "admin")
    render json: @admins, status: :ok
  end

  def approve_freelancer
    freelancer_user = User.find_by_uuid(params[:id])
    if freelancer_user
      freelancer_user.account_approved = true
      freelancer_user.save
      render json: { success: true, message: "Profile approved", status: 200 }
    else
      render_error("Not found", 401)
    end
  end

  def block_freelancer
    freelancer_user = User.find_by_uuid(params[:id])
    if freelancer_user
      freelancer_user.account_active = false
      freelancer_user.save
      render json: { success: true, message: "Profile blocked", status: 200 }
    else
      render_error("Not found", 401)
    end
  end

  def admin_filter
    if params[:search_freelancers].present? || params[:search_jobs].present?
      original_filters = JSON.parse(params[:search_freelancers] || params[:search_jobs]).symbolize_keys
      original_filters = original_filters.reject { |key,value| value.empty? }
    end

    if original_filters.present? || params[:status].present?
      search_by, where_data, certificate_data = create_search_fields(original_filters)
      sorted_data = []

      model = params[:search_freelancers].present? ? User : Job
      search_fields = params[:search_freelancers].present? ? [:user_category] : [:job_category]
      serializer = params[:search_freelancers].present? ? FreelancerSerializer : JobSerializer

      filtered_data = model.search(search_by, where: where_data, fields: search_fields)

      # if params[:search_freelancers].present?
      #   filtered_data = filtered_data.select{|data| (data.role == "freelancer" && data.profile_created == true)} 
      # # else
      # #   filtered_data = filtered_data.select{|data| (data.job_visibility == "Anyone")} 
      # end
     
      if params[:status].present?
        if where_data.present? || filtered_data.present?
          data_to_sort_by = model.where(id: filtered_data.map(&:id))
          sorted_data = data_to_sort_by.search_by_status(params[:status])
        else
          sorted_data = model.search_by_status(params[:status])
        end
        filtered_records = sorted_data.uniq.sort_by {|s| s.created_at}.reverse
      else
        filtered_records = filtered_data.uniq.sort_by {|s| s.created_at}.reverse
      end
      #filtered_records = (filtered_data.push(sorted_data)).flatten.uniq.sort_by {|s| s.created_at}.reverse
    elsif params[:find_freelancers].present?
      filtered_records = User.search_by_status(params[:status])
    elsif params[:find_jobs]
      filtered_records = Job.search_by_status(params[:status])
    end

    if certificate_data.present?
      if filtered_data.blank?
        filtered_records = params[:search_freelancers].present? ? (User.search_by_status(params[:status])) : (Job.search_by_status(params[:status]))
      end
      if params[:search_freelancers].present?
        filtered_records = filtered_records.select{|s| certificate_data == "Yes" ? (s.profile.certifications.present?) : (s.profile.certifications.blank?)}
      elsif params[:search_jobs].present?
        filtered_records = filtered_records.select{|s| certificate_data == "Yes" ? (s.job_qualifications.present? && s.job_qualifications[0].qualification_group != "No") : (s.job_qualifications.blank? || s.try(:job_qualifications)[0].try(:qualification_group) == "No")}
      end
    end
    if params[:search].present?
      if params[:search_freelancers].present?
        filtered_records = filtered_records.select{|s| s.first_name.downcase == params[:search].downcase || s.last_name.downcase == params[:search].downcase}
      elsif params[:search_jobs].present? || params[:find_jobs].present?
        filtered_records = filtered_records.select{|s| s.job_title.downcase.include?(params[:search].downcase)}
      end
    end

    if params[:search_freelancers].present? || params[:find_freelancers].present?
      render json: (filtered_records.present? ? filtered_records : []), each_serializer: FreelancerSerializer, include: 'profile', status: :ok
    elsif params[:search_jobs].present? || params[:find_jobs].present?
      render json: (filtered_records.present? ? filtered_records : []), each_serializer: JobSerializer, status: :ok
    end
  end

  private
  def create_search_fields(filters)
    certificate_data = filters[:certification]
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

    if filters[:certification].present?
      filters.delete(:certification)
    end

    where_data = filters

    search_by = where_data.present? ? "*" : "" if search_by.blank?
    return search_by, where_data, certificate_data
  end

end
