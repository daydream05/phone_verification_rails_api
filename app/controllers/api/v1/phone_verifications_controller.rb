class Api::V1::PhoneVerificationsController < ApplicationController
  def start
    response = Authy::PhoneVerification.start(via: "sms", country_code: 1, phone_number: phone_number_params)

    if response.ok?
      # verification was started
      render json: { success: true, message: "Verification code was sent to your phone number"}, status: :ok
    else
      render json: response
    end
  end

  def check
    phone_number = phone_verification_params[:phone_number]
    verification_code = phone_verification_params[:verification_code]

    response = Authy::PhoneVerification.check(verification_code: verification_code, country_code: 1,
                                              phone_number: phone_number)

    if response.ok?
      # verification code was accepted
      user = current_user
      if !user.blank?
        # if the user exists, then we can update their phone number
        user.update(phone_number)
        render json: { success: true, message: "Phone number was successfully verified and user's phone number has been updated"},
               status: 201
      else
        # this means that the user is not logged in, or the user has not been created yet.
        # just tell the client the phone verification was succesful
        render json: response
      end
    else
      render json: response
    end
  end

  private
  def phone_verification_params
    params.require(:phone_verification).permit(:phone_number, :verification_code)
  end

  def phone_number_params
    params.require(:phone_verification).permit(:phone_number)
  end
end
