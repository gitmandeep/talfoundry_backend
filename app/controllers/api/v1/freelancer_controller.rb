class Api::V1::FreelancerController < Api::V1::ApiController
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
    render json: freelancer_users, each_serializer: FreelancerSerializer, status: :ok
  end

  def get_invites
    invites = @current_user.invites.open_invites.present? ? @current_user.invites.open_invites.order(created_at: :desc) : []
    render json: invites, each_serializer: FreelancerInviteSerializer, status: :ok
  end

  def get_submitted_proposals
    submitted_proposals = @current_user.job_applications.present? ? @current_user.job_applications.order(created_at: :desc) : []
    render json: submitted_proposals, each_serializer: SubmittedProposalSerializer, status: :ok
  end

  def freelancer_details
    freelancer = User.find_by_uuid(params[:id])
    if freelancer
      render json: freelancer, serializer: FreelancerSerializer, status: :ok
    else
      render_error('Invalid user', 401)
    end
  end

end
