module Api
  module V1
    class PostsController < ApplicationController
      def create
        result = PostCreatorService.new(post_params, params[:user_login], request.remote_ip).call

        render json: { message: result[:message] }, status: result[:status]
      end

      def recurrent_ips
        result = PostAnalyticsService.recurrent_ips

        render json: { recurrent_ips: result }
      end

      private

      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end
