module Api
  module V1
    class TicketsController < ApiController

      def index
        scope = Ticket.includes(:ticket_line_items, ticket_tags: [:tag])
        scope = scope.where("wager_date >= ?", params[:start_date]) if params[:start_date]
        scope = scope.where("wager_date <= ?", params[:stop_date]) if params[:stop_date]
        scope
        render json: scope
      end

      def show
        render json: Ticket.find(params[:ticket_id])
      end

    end
  end
end
