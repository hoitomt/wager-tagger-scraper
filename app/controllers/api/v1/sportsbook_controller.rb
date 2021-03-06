module Api
  module V1
    class SportsbookController < ApiController
      before_filter :verify_sb_credentials

      def recent_tickets
        sb = SB::SportsbookData.new(ENV['SB_USERNAME'], ENV['SB_PASSWORD'])
        tickets = sb.recent_tickets(params[:start_date])
        ticket_ids = tickets.blank? ? [] : tickets.map(&:id)
        @count = ticket_ids.length
        render_response({ticket_ids: ticket_ids})
      end

      def all_tickets
        sb = SB::SportsbookData.new(ENV['SB_USERNAME'], ENV['SB_PASSWORD'])
        tickets = sb.all_tickets
        ticket_ids = tickets.blank? ? [] : tickets.map(&:id)
        @count = ticket_ids.length
        render_response({ticket_ids: ticket_ids})
      end

      def verify_authentication
        render json: {result: "success"}
      end

      private
      def restrict_access
        unless Rails.env.development?
          authenticate_or_request_with_http_token do |token, options|
            ApiKey.exists?(access_token: token)
          end
        end
      end

      def verify_sb_credentials
        @sb_username = ENV['SB_USERNAME']
        @sb_password = ENV['SB_PASSWORD']
        if @sb_username.blank? || @sb_password.blank?
          render json: {error: "Sportsbook Username and or Password are missing"} and return
        end
        unless SB::SportsbookData.new(@sb_username, @sb_password).logged_in?
          render json: {error: "There is an issue with your Sportsbook credentials"} and return
        end
      end
    end
  end
end
