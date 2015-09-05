module Api
  module V1
    class TicketTagsController < ApiController

      def create
        ticket_tag = TicketTag.new(ticket_tag_params)
        if ticket_tag.save
          render json: ticket_tag
        else
          render json: {errors: ticket_tag.errors.full_messages}, status: 422
        end
      end

      def destroy
        ticket_tag = TicketTag.find_by_id(params[:id])
        if ticket_tag && ticket_tag.destroy
          render json: {}, status: 200
        else
          render json: {errors: ticket_tag.errors.full_messages}, status: 422
        end
      end

      private

      def ticket_tag_params
        params.permit(:ticket_id, :tag_id, :amount)
      end

    end
  end
end
