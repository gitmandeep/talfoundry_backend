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

  def get_active_offers
    offers = @current_user.received_contracts.active_offer.present? ? @current_user.received_contracts.active_offer.order(created_at: :desc) : []
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
end
