class SubscribedUser < ApplicationRecord

  def send_confirmation
    token = generate_token
    self.update(token: token)
    UserMailer.new.send_confirmation(self, token)
  end

  protected

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end

end
