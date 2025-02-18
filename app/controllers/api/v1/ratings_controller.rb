module Api
  module V1
    class RatingsController < ApplicationController
      def create
        result = RatingCreatorService.new(rating_params).call

        render json: { message: result[:message] }, status: result[:status]
      end

      private

      def rating_params
        params.require(:rating).permit(:post_id, :user_id, :value)
      end
    end
  end
end
