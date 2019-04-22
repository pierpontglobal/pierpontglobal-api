module Api
  module V1
    module Notification
      class NotificationsController < Api::V1::BaseController
        skip_before_action :active_user?

        def show_by_current_user
          notifications = ::Notification.where(:receiver_id => current_resource_owner[:id], :read_at => nil).order('created_at DESC')
          render json: notifications, :status => :ok
        end

        def add_notification_to_current_user
          if !exists(params)

            issue = ::Issue.find_by(:custom_id => params[:issue_id])
            issue_id = issue.present? ? issue[:id] : nil
            NotificationHandler.send_notification(params[:title], params[:message], params[:payload], @user[:id], params[:type], issue_id)

            render json: {
                message: "SENT"
            }, :status => :ok

          else
            render json: {
                message: "NOT SENT"
            }, :status => :ok
          end
        end

        def read_notification
          if params[:id].present?

            notification = ::Notification.find(params[:id])
            notification.read_at = Time.now

            notification.save!

            render json: notification.sanitazed_info, :status => :ok

          else
            render json: {
                error: "Please, provide an id"
            }, :status => :bad_request
          end
        end

        def read_all
          ids = params[:ids]
          if params[:ids].present?
            ::Notification.where(:id => ids).each { |n|
              n[:read_at] = Time.now
              n.save!
            }
            render json: ::Notification.where(:receiver_id => current_resource_owner[:id], :read_at => nil), :status => :ok
          else
            render json: {
                error: "Please, provide the notifications ids"
            }, :status => :bad_request
          end
        end


        private

        def exists(params)
          notifications = ::Notification.where("data ->> 'title' = ? and data ->> 'message' = ? and notification_type = ? and receiver_id = ? and read_at is null",
                                               params[:title], params[:message], params[:type], @user[:id])

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