# frozen_string_literal: true

require 'sendgrid-ruby'
module Mailers
  # Handles the transactional mailer for the registration process
  class MailerDevise < Devise::Mailer
    default template_path: 'mailers'

    # Sends transactional email for confirmation instructions
    def confirmation_instructions(record, token, _opts = {})
      data = load_confirmation_template(token, record)
      j_data = JSON.parse(data.to_json)

      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      response = sg.client.mail._('send').post(request_body: j_data)
      p response
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
end
end
