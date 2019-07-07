# frozen_string_literal: true

module Api
  module V1
    module Notification
      # Handles the in-site and push notifications
      class NotificationsController < Api::V1::UserBaseController

        def show_by_current_user
          notifications = ::Notification.where(receiver_id: current_user[:id], read_at: nil).order('created_at DESC')
          render json: notifications, status: :ok
        end

        def add_notification_to_current_user

          notifications = params[:notifications]
          sent = []

          if notifications.present?
            notifications.each do |n|
              if !exists(n[:title], n[:message], n[:type])
                issue = ::Issue.find_by(custom_id: n[:issue_id])
                issue_id = issue.present? ? issue[:id] : nil
                NotificationHandler.send_notification(n[:title], n[:message], n[:payload], current_user[:id], n[:type], issue_id)
                sent << n
              end
            end

            if sent.any?
              render json: {
                  message: 'SENT',
                  notifications_sent: sent
              }, status: :ok
            else
              render json: {
                  message: 'NOT SENT',
              }, status: :ok
            end

          else
            render json: {
              message: 'Please provide an array of notifications.'
            }, status: :bad_request
          end
        end

        def read_notification
          if params[:id].present?

            notification = ::Notification.find(params[:id])
            notification.read_at = Time.now

            notification.save!

            render json: notification.sanitazed_info, status: :ok

          else
            render json: {
              error: 'Please, provide an id'
            }, status: :bad_request
          end
        end

        def read_all
          ids = params[:ids]
          if params[:ids].present?
            ::Notification.where(id: ids).each do |n|
              n[:read_at] = Time.now
              n.save!
            end
            render json: ::Notification.where(receiver_id: current_user[:id], read_at: nil), status: :ok
          else
            render json: {
              error: 'Please, provide the notifications ids'
            }, status: :bad_request
          end
        end

        private

        def exists(title, message, type)
          notifications = ::Notification.where(
            "data ->> 'title' = ? and data ->> 'message' = ? and notification_type = ? and receiver_id = ? and read_at is null",
            title,
            message,
            type,
            current_user[:id]
          )

          if notifications.any?
            return true
          else
            return false
          end
        end
      end
    end
  end
end
