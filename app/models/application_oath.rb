class ApplicationOath < ApplicationRecord
  has_secure_token :pk
  before_create :set_secret_key

  private

  def set_secret_key
    self.sk = generate_token
  end

  def generate_token
    loop do
      token = SecureRandom.hex(20)
      break token unless ApplicationOath.where(sk: token).exists?
    end
  end
end
