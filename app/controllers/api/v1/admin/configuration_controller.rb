# frozen_string_literal: true

module Api
  module V1
    module Admin

      # Allow the administrator to control the web site configurations
      class ConfigurationController < Api::V1::AdminBaseController
        def register_ip
          config_methods = ConfigMethods.new
          config_methods.register_ip
          render json: { status: 'success' }, status: :ok
        end
      end
    end
  end
end
