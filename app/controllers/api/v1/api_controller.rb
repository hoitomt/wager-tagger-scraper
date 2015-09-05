module Api
  module V1
    class ApiController < ApplicationController
      def verify_authentication
        render json: {result: "success"}
      end

      # Used by active model serializers to configure the resopnse
      def default_serializer_options
        {root: false}
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
