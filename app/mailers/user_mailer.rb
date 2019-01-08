# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'support@pierpontglobal.com'

  def send_confirmation(subscribed_user, token)
    set_client
    @user = subscribed_user
    template = load_confirmation_template(token, @user)
    data = JSON.parse(template.to_json)
    @sg.client.mail._('send').post(request_body: data)
  end

  private

  def load_confirmation_template(token, user)
    { personalizations: [
      {
        to: [email: user.email],
        dynamic_template_data: {
          user_name: "#{user.first_name} #{user.last_name}",
          host: Rails.env.production? ? 'https://pierpontglobla.com' : 'http://0.0.0.0:3001',
          token: token
        }
      }
    ], from: { email: ENV['SOURCE_EMAIL'] },
      template_id: 'd-1e8f30ef9ec54e24a5ccdbd6b8cf368c' }
  end

  protected

  def set_client
    @sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  end
end
