module Confirmations
  def self.send_confirmation_to(user)
    if private_code_request_valid?(user)
      MessageSender.send_message(user.phone_number, "Your Pierpont Global verification code is: #{user.verification_code}")
      return true
    end

    verification_code = CodeGenerator.generate
    user.update(verification_code: verification_code,
                activation_code_sent_at: Time.now,
                activation_code_valid_for: 30.minutes)
    MessageSender.send_message(
      user.phone_number,
      "Your Pierpont Global verification code is: #{verification_code}"
    )
    true
  end

  def self.verify_code(user, code)
    return true if user.phone_number_validated
    if private_code_valid?(user, code)
      user.update!(phone_number_validated: true)
      return true
    end
    false
  end

  def self.send_token_verification(token)
    token = Doorkeeper::AccessToken.find_by(token: token)
    user = User.find(token.resource_owner_id)

    if token.mfa_authenticated
      MessageSender.send_message(
        user.phone_number,
        'This session has already been verified.'
      )
      return
    end

    if private_token_request_valid?(token)
      MessageSender.send_message(
        user.phone_number,
        "Your Pierpont Global verification code is: #{token.phone_code}"
      )
      return true
    end

    verification_code = CodeGenerator.generate
    token.update(phone_code: verification_code,
                 phone_code_sent_at: Time.now,
                 phone_code_valid_till: 30.minutes)

    MessageSender.send_message(
      user.phone_number,
      "Your Pierpont Global verification code is: #{verification_code}"
    )
  end

  def self.confirm_token(token, code)
    return true if token.mfa_authenticated
    if private_token_valid?(token, code)
      token.update!(mfa_authenticated: true)
      return true
    end
    false
  end

  ##############################################################################
  # Private methods START
  ##############################################################################

  def self.private_code_valid?(user, code)
    (user.verification_code == code) && ((user.activation_code_sent_at + user.activation_code_valid_for) < Time.now)
  end

  def self.private_code_request_valid?(user)
    user.verification_code && ((user.activation_code_sent_at + user.activation_code_valid_for) < Time.now)
  end

  def self.private_token_valid?(token, code)
    (token.phone_code == code) && ((token.phone_code_sent_at + token.phone_code_valid_till) > Time.now)
  end

  def self.private_token_request_valid?(token)
    token.phone_code && ((token.phone_code_sent_at + token.phone_code_valid_till) > Time.now)
  end

  ##############################################################################
  # Private methods END
  ##############################################################################
end