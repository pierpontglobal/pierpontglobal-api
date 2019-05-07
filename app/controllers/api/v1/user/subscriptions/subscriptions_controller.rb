# frozen_string_literal: true

require 'stripe'

module Api
  module V1
    module User
      module Subscriptions
        # Handles the users related calls
        class SubscriptionsController < Api::V1::BaseController
          skip_before_action :active_user?
          before_action :stripe_user

          Stripe.api_key = ENV['STRIPE_KEY']

          def payment
            invoice = Stripe::Invoice.retrieve(params['invoice_id'])
            invoice.pay
            render json: invoice, status: :ok
          end

          def attach_subscription
            subscription = Stripe::Subscription.create(
              customer: @user_stripe.id,
              items: [
                {
                  plan: 'plan_ELmsSxYxjI36gE'
                }
              ]
            )
            render json: subscription, status: :ok
          end

          def subscription_view
            subscription = @user_stripe.subscriptions.data.first
            product = Stripe::Product.retrieve(subscription.plan.product)
            default_card = @user_stripe.sources.retrieve(@user_stripe.default_source)
            payments = @user_stripe.charges
            subscription_info = {
              id: subscription.id,
              billing_type: subscription.billing,
              cancelled_at: subscription.canceled_at,
              last_billing: Time.at(subscription.billing_cycle_anchor),
              days_until_due: Time.at(subscription.days_until_due || 0),
              created_at: Time.at(subscription.created),
              current_period_end: Time.at(subscription.current_period_end),
              current_period_start: Time.at(subscription.current_period_start),
              plan_name: product.name,
              plan_id: subscription.plan.id,
              amount: subscription.plan.amount,
              interval: subscription.plan.interval,
              active: subscription.plan.active
            }
            primary_payment_method = {
              id: default_card.try(:id),
              brand: default_card.try(:brand),
              exp_month: default_card.try(:exp_month),
              exp_year: default_card.try(:exp_year),
              last4: default_card.try(:last4)
            }
            payments_history = payments.map do |payment|
              {
                id: payment.id,
                amount: payment.amount,
                paid: payment.paid,
                status: payment.status,
                descriptor: payment.description || payment.statement_descriptor,
                card: {
                  id: payment.source.try(:id),
                  brand: payment.source.try(:brand),
                  exp_month: payment.source.try(:exp_month),
                  exp_year: payment.source.try(:exp_year),
                  last4: payment.source.try(:last4)
                },
                payment_intent: payment.payment_intent,
                invoice: payment.invoice,
                receipt_number: payment.receipt_number,
                data: payment
              }
            end

            total_amount_due = 0
            pending_invoices = @user_stripe.invoices(paid: false).data.map do |pending_invoice|
              description = pending_invoice.billing_reason
              if description == 'subscription_create'
                description = 'Subscription payment for "Pierpont Global USA Access"'
              end
              total_amount_due += pending_invoice.amount_due
              {
                id: pending_invoice.id,
                amount_due: pending_invoice.amount_due,
                descriptor: description,
                data: pending_invoice,
                status: "#{pending_invoice.status.capitalize} untill #{Time.at(pending_invoice.due_date).strftime('%d/%b/%Y')}"
              }
            end

            if pending_invoices.present?
              NotificationHandler.send_notification('Pending invoices',
        "Total Amount due: #{total_amount_due}. Please pay your invoices as soon as possible.", pending_invoices,
                  @user[:id], ::Notification::ALERT_NOTIFICATION)
            end

            render json: {
              subscription_info: subscription_info,
              primary_payment_method: primary_payment_method,
              payments_history: payments_history,
              pending_invoices: pending_invoices
            }
          end

          def pending_invoices
            # TODO: Implement this
          end

          def current_subscription
            subscription = @user_stripe.subscriptions.data.first
            product = Stripe::Product.retrieve(subscription.plan.product)
            render json: {
              id: subscription.id,
              billing_type: subscription.billing,
              cancelled_at: subscription.canceled_at,
              last_billing: Time.at(subscription.billing_cycle_anchor),
              days_until_due: Time.at(subscription.days_until_due || 0),
              created_at: Time.at(subscription.created),
              current_period_end: Time.at(subscription.current_period_end),
              current_period_start: Time.at(subscription.current_period_start),
              plan_name: product.name,
              plan_id: subscription.plan.id,
              amount: subscription.plan.amount,
              interval: subscription.plan.interval,
              active: subscription.plan.active,
              paid: (@user_stripe.invoices(paid: false).data.size < 1)
            }, status: :ok
          rescue
            render json: { message: "No subscription" }, status: :ok
          end

          def retrieve_payments
            render json: @user_stripe.charges, status: :ok
          end

          def modify_renew_status
            subscription = @user_stripe.subscriptions.data.first
            if params['status'] == 'true'
              subscription.billing = 'charge_automatically'
            else
              subscription.billing = 'send_invoice'
              subscription.days_until_due = 30
            end
            subscription.save
            render json: subscription, status: :ok
          end

          private

          def stripe_user

            @user_stripe = Stripe::Customer.retrieve(@user.stripe_customer)

          rescue Stripe::APIConnectionError => e
            render json: { message: 'Connection with stripe failed', error: e }, status: :service_unavailable

          rescue StandardError => e
            render json: { message: 'Not associated billable identity', error: e }, status: :not_found
            nil # Close request
          end
        end
      end
    end
  end
end
