class Api::V1::PaymentsController < Api::V1::ApiController
	before_action :authorize_request

  def authenticate_payment_method
    tokeninfo = Tokeninfo.create(params[:code])
    user_info = tokeninfo.userinfo
    user_info = user_info.to_hash

    payment_method = User.find(params[:id]).payment_methods.build(user_account_id: user_info["user_id"], name: user_info["name"], email: user_info["email"], account_type: "paypal", payer_id: user_info["payer_id"], verified: user_info["verified"], email_verified: user_info["email_verified"])
    if payment_method.save! && payment_method.verified
      render json: {success: true, message: "User account verified", status: 200}
    else
      render_error("Something went wrong", 401)
    end
  end

  def set_payment_method
    payment_method = current_user.payment_methods.build(name: current_user.display_full_name, email: current_user.email, account_type: params[:account_type])
    if payment_method.save!
      render json: {success: true, message: "Account added successfully", status: 200}
    else
      render_error("Something went wrong", 401)
    end
  end

  def remove_payment_method
    payment_method = current_user.payment_methods.where(account_type: params[:account_type])
    if payment_method.destroy_all
      render json: {success: true, message: "Account removed successfully", status: 200}
    else
      render_error("Something went wrong", 401)
    end
  end

end
