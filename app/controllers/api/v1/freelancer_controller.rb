class Api::V1::FreelancerController < Api::V1::ApiController
  include Api::V1::Concerns::Search
  before_action :authorize_request

  def freelancer_index
    if @current_user.is_admin?
      freelancer_users = User.admin_freelancer_index
    elsif @current_user.is_hiring_manager? || @current_user.is_freelancer?
      if params[:search].present?
        freelancer_users = User.search(params[:search])
      elsif params[:search_by_category].present?
        freelancer_users = User.search(params[:search_by_category], fields: [:user_category])
      end

      if freelancer_users
        freelancer_users = freelancer_users.results.select{|fu| (fu.role == "freelancer" && fu.account_approved == true && fu.id != @current_user.id )}
      else
        freelancer_users = User.manager_freelancer_index
      end
    end

    if @current_user.is_hiring_manager? && params[:search].present?
      if @current_user.search_histories.where("keyword ~* ?", params[:search]).order(created_at: :desc).limit(5).uniq.blank?
        create_search_history(params[:search])
      end
    end
    favorited_freelancers = @current_user.favorites_freelancers.pluck(:id) rescue []
    render json: freelancer_users, each_serializer: FreelancerSerializer, favorited_freelancers: favorited_freelancers, status: :ok
  end

  def get_invites
    invites = @current_user.invites.open_invites.present? ? @current_user.invites.open_invites.order(created_at: :desc) : []
    render json: invites, each_serializer: FreelancerInviteSerializer, status: :ok
  end

  def get_offers
    offers = @current_user.received_contracts.pending_offer.present? ? @current_user.received_contracts.pending_offer.order(created_at: :desc) : []
    render json: offers, each_serializer: FreelancerOfferSerializer, status: :ok
  end

  def active_contracts
    offers = @current_user.received_contracts.active_contract.present? ? @current_user.received_contracts.active_contract.order(created_at: :desc) : []
    render json: offers, each_serializer: FreelancerOfferSerializer, status: :ok
  end

  def get_submitted_proposals
    submitted_proposals = @current_user.job_applications.present? ? @current_user.job_applications.order(created_at: :desc) : []
    render json: submitted_proposals, each_serializer: SubmittedProposalSerializer, status: :ok
  end

  def freelancer_details
    freelancer = User.find_by_uuid(params[:id])
    favorited_freelancers = @current_user.favorites_freelancers.pluck(:id) rescue []
    if freelancer
      render json: freelancer, serializer: FreelancerSerializer, favorited_freelancers: favorited_freelancers, status: :ok
    else
      render_error('Invalid user', 401)
    end
  end

  def hire_freelancer_details
    freelancer = User.find_by_uuid(params[:id])
    job_id = Job.find_by_uuid(params[:job_uuid]).try(:id)
    if freelancer
      render json: freelancer, serializer: HireFreelancerSerializer, job_id: job_id, status: :ok
    else
      render_error('Invalid user', 401)
    end
  end

  def filter_freelancers
    if @current_user.is_hiring_manager?
      search_by, where_data = create_search_fields if params[:search].present?
      sorted_freelancers = []

      filtered_freelancers = User.search(search_by, where: where_data, fields: [:user_category])
      filtered_freelancers = filtered_freelancers.select{|fu| (fu.account_approved == true )}

      if params[:sort_by].present?
        if filtered_freelancers.present?
          freelancers_to_sort_by = User.where(id: filtered_freelancers.map(&:id))
          sorted_freelancers = freelancers_to_sort_by.send(params[:sort_by].downcase).approved
        else
          sorted_freelancers = User.send(params[:sort_by].downcase).approved
        end
      end
      freelancers = (filtered_freelancers.push(sorted_freelancers)).flatten.uniq.sort_by {|s| s.created_at}.reverse
      render json: freelancers, each_serializer: FreelancerSerializer, status: :ok
    else
      render_error('Invalid user', 401)
    end
  end

  private
  def create_search_fields
    filters = JSON.parse(params[:search])
    filters = filters.symbolize_keys
    if filters[:location].present?
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
    
    where_data = filters

    if search_by.blank?
      search_by = where_data.present? ? "*" : ""
    end
    return search_by, where_data
  end
end
