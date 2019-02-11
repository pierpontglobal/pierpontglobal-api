# frozen_string_literal: true

require 'stripe'

module Api
  module V1
    module User
      module Transactions
        # Handles the users related calls
        class TransactionsController < Api::V1::BaseController
          skip_before_action :active_user?

          def show_manual_transactions
            # TODO: Allow the user to review the manual transactions performed by an administrator
          end
        end
      end
    end
  end
end
