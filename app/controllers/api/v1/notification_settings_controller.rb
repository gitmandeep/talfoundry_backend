class Api::V1::NotificationSettingsController < Api::V1::ApiController
  before_action :authorize_request

  def show
    notification_setting = @current_user.notification_setting
    notification_setting.present? ? (render json: notification_setting, serializer: NotificationSettingSerializer, status: :ok) : (render json: { error: 'Not found' }, status: 404)
  end

  def update
    if @current_user.notification_setting.update(notification_setting_params)
      render json: {succes: true, status: 200}
    else
      render_error("Not updated", 422)
    end
  end

  private

  def notification_setting_params
    params.require(:notification_setting).permit(:someone_sends_me_an_invitation, :a_job_is_posted_or_modified, :a_proposal_is_received, :an_interview_is_accepted_or_offer_terms_are_modified, :an_interview_or_offer_is_declined_or_withdrawan, :an_offer_is_accepted, :a_job_posting_will_expire_soon, :a_job_posting_expired, :an_interview_is_initiated, :an_offer_or_interview_invitation_is_received, :an_offer_or_interview_invitation_is_withdrawn, :a_proposal_is_rejected, :a_job_I_applied_to_has_been_cancelled_or_closed, :a_hire_is_made_or_a_contract_begins, :contract_terms_are_modified, :a_contract_ends, :payment_receipts_and_other_finacial_related_emails)
  end


end
