module Api
  module V1
    class TagsController < ApiController

      def index
        render json: Tag.all
      end

    end
  end
end
