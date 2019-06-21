module Api
  module V1
    module User
      module Token
        # Controls the token activation and deactivation tied to 2FA
        class TokensController < Api::V1::UserBaseController

          def activate
            sendable_token = generate_secure_numeric_token
            user.numeric_activation_token = sendable_token
            user.save!
          end

          def deactivate
            user.is_token_active = false
            user.numeric_activation_token = nil
            user.save!
          end

          private

          def generate_secure_numeric_token
            (SecureRandom.rand * 1000000).floor
          end

        end
      end
    end
  end
end