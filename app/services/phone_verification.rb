class PhoneVerification
  attr_reader :user

  def initialize(options)
    @user = User.find(options[:user_id])
  end

  def send_sms
    begin
      account_sid = "AC448de0da8613bf6ef947e5707523481e"
      auth_token = "6780efd10e78ccc43ae751c808c8a3a6"
      Rails.logger.info "SMS: From: +13174276190 To: #{to} Body: \"#{body}\""
      client = Twilio::REST::Client.new account_sid, auth_token

      client.messages.create(
        from: '+13174276190',
        # to: '+917987392544',
        to: to,
        body: body
      )
    rescue Twilio::REST::RestError => error
      @error = error
      return false
    end
  end

  private

  # def from
  #   # Add your twilio phone number (programmable phone number)
  #   Twilio.configuration.from
  #   # Settings.twilio_number_for_app
  # end

  def to
    "#{user.phone_number}"
  end

  def body
    "Please reply with this code '#{user.phone_verification_code}' to verify your phone number"
  end

  # def twilio_client
  #   # Pass your twilio account sid and auth token
  #   @twilio ||= Twilio::REST::Client.new(Settings.twilio_account_sid,
  #                                        Settings.twilio_auth_token)
  # end

end