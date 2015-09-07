module Api
  module V1
    class FinancesController < ApiController

      def index
        finances = Finance.all(params[:start_date], params[:stop_date])
        # Note to self - use to_json to avoid the serializer
        render json: finances.to_json
      end

    end
  end
end
