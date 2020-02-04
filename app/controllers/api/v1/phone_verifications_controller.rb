class Api::V1::PhoneVerificationsController < Api::V1::ApiController

  def verify_user_from_otp
    user = get_user_for_phone_verification
    if user
      user.mark_phone_as_verified!
      render json: user, message: "Phone number verified", success: true, status: 200
    else
      render_error("Invalid OTP", 401)
    end
  end

  def send_otp
    @user = User.find(params[:id])
    @user.set_phone_attributes(params[:phone_number])
    message = PhoneVerification.new(user_id: @user.id)
    if message.send_sms
      render json: "Phone number verified", success: true, status: 200
    else
      render_error("#{message.error}", 401)
    end
  end

  private

  def get_user_for_phone_verification
    phone_verification_code = params['otp'].try(:strip)
    phone_number = params[:phone]
    condition = { phone_verification_code: phone_verification_code, phone_number: phone_number }
    User.unverified_phones.where(condition).first
  end
end
