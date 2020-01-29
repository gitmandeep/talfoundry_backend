class Api::V1::PhoneVerificationsController < Api::V1::ApiController

  def verify_from_message
    user = get_user_for_phone_verification
    user.mark_phone_as_verified! if user

    render json: "Phone number verified", success: true, status: 200
  end

  private

  def get_user_for_phone_verification
    phone_verification_code = params['otp'].try(:strip)
    phone_number            = params['phone'].gsub('+1', '')

    condition = { phone_verification_code: phone_verification_code,
                  phone_number: phone_number }

    User.unverified_phones.where(condition).first
  end
end
