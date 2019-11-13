class Api::V1::FreelancerController < Api::V1::ApiController
  before_action :authorize_request

  def freelancer_index
    if @current_user.role == "admin"
      freelancer_users = User.admin_freelancer_index
    elsif @current_user.role == "Project Manager" || @current_user.role == "freelancer"
      if params[:search].present?
        freelancer_users = User.search(params[:search])
        freelancer_users = freelancer_users.results.select{|fu| (fu.role == "freelancer" && fu.account_approved == true && fu.id != @current_user.id )}
      else
        freelancer_users = User.manager_freelancer_index
      end
    end
    render json: freelancer_users, each_serializer: FreelancerSerializer, status: :ok
  end

  def get_invitations
    invites = @current_user.invites.open_invites.present? ? @current_user.invites.open_invites : []
    render json: invites, each_serializer: FreelancerInviteSerializer, status: :ok
  end

  def get_submitted_proposals
    submitted_proposals = @current_user.job_applications.present? ? @current_user.job_applications : []
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
