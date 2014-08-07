module Api
  module V1
    class TicketsController < ApplicationController
      before_filter :restrict_access

      def index
        if params[:limit].present? && params[:page].blank?
          render json: {error: "A limit cannot be specified with out a page"} and return
        end
        tickets = Ticket.search(params)
        @count = tickets.length
        render_response tickets
      end

      def recent
        sb = SB::SportsbookData.new(ENV['SB_USERNAME'], ENV['SB_PASSWORD'])
        tickets = sb.recent_tickets(params[:start_date])
        ticket_ids = tickets.blank? ? [] : tickets.map(&:id)
        @count = ticket_ids.length
        render_response({ticket_ids: ticket_ids})
      end

      def all
        sb = SB::SportsbookData.new(ENV['SB_USERNAME'], ENV['SB_PASSWORD'])
        tickets = sb.all_tickets
        ticket_ids = tickets.blank? ? [] : tickets.map(&:id)
        @count = ticket_ids.length
        render_response({ticket_ids: ticket_ids})
      end

      private
      def restrict_access
        authenticate_or_request_with_http_token do |token, options|
          ApiKey.exists?(access_token: token)
        end
      end
    end
  end
end