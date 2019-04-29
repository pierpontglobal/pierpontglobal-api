# frozen_string_literal: true

require 'sendgrid-ruby'
module Mailers
  # Handles the transactional mailer for the registration process
  class MailerDevise < Devise::Mailer
    default template_path: 'mailers'

    def contact_message(email, phone, name, company, message)
      set_client
      data = load_contact_form_template(email, phone, name, company, message)
      j_data = JSON.parse(data.to_json)
      @sg.client.mail._('send').post(request_body: j_data)
    end

    def password_change(email, token, callback)
      set_client
      data = load_password_change_template(token, email, callback)
      j_data = JSON.parse(data.to_json)
      @sg.client.mail._('send').post(request_body: j_data)
    end

    # Sends transactional email for confirmation instructions
    def confirmation_instructions(record, token, opts = {})
      set_client
      # if record.confirmed_at.nil?
      #   data = load_confirmation_template(token, record)
      #   j_data = JSON.parse(data.to_json)
      #   @sg.client.mail._('send').post(request_body: j_data)
      # end
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

    def load_contact_form_template(userEmail, phone, name, company, message )
      { personalizations: [
          {
              to: [email: 'digrape07@gmail.com'],
              dynamic_template_data: {
                  user_phone: phone,
                  user_name: name,
                  user_company: company,
                  user_message: message
              }
          }
      ], from: { email: userEmail },
        template_id: 'd-ec2dca6cc9f44a5e8211b71e43f35618' }
    end

    protected

    def set_client
      @sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    end
  end
end
