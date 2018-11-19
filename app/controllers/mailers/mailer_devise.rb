# frozen_string_literal: true

require 'sendgrid-ruby'
module Mailers
  # Handles the transactional mailer for the registration process
  class MailerDevise < Devise::Mailer
    default template_path: 'mailers'

    def password_change(email, token, callback)
      set_client
      data = load_password_change_template(token, email, callback)
      j_data = JSON.parse(data.to_json)
      @sg.client.mail._('send').post(request_body: j_data)
    end

    # Sends transactional email for confirmation instructions
    def confirmation_instructions(record, token, opts = {})
      set_client
      data = load_confirmation_template(token, record)
      j_data = JSON.parse(data.to_json)
      @sg.client.mail._('send').post(request_body: j_data)
    end

    private

    # Fills a json formatted object with the required data to send a confirmation
    # email with the configured template at SendGrid.
    def load_confirmation_template(token, record)
      { personalizations: [
        {
          to: [email: record.email],
          dynamic_template_data: {
            host_url: '0.0.0.0:3000',
            confirmation_token: token
          }
        }
      ], from: { email: ENV['SOURCE_EMAIL'] },
        template_id: 'd-1e8f30ef9ec54e24a5ccdbd6b8cf368c' }
    end

    def load_password_change_template(token, email, callback)
      { personalizations: [
        {
          to: [email: email],
          dynamic_template_data: {
            callback: callback,
            token: token
          }
        }
      ], from: { email: ENV['SOURCE_EMAIL'] },
        template_id: 'd-16b03d18163947a7b7cb79a102024f2b' }
    end

    protected

    def set_client
      @sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    end
  end
end
