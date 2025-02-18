require 'rails_helper'

RSpec.describe Api::V1::RatingsController, type: :request do
  let(:first_post) { create(:post) }
  let(:second_post) { create(:post, title: 'Second Post') }
  let(:user) { create(:user) }

  describe "POST /api/v1/ratings" do
    context "when success" do
      before do
        post "/api/v1/ratings", params: { rating: { value: 3, user_id: user.id, post_id: first_post.id } }
      end

      it "returns status created" do
        expect(response).to have_http_status(:created)
      end

      it "returns the correct average rating" do
        expect(response.parsed_body["message"]["average_rating"]).to eq 3.0
      end
    end

    context "when failure" do
      context "with missing data" do
        before do
          post "/api/v1/ratings", params: { rating: { value: '', user_id: user.id, post_id: '' } }
        end

        it "returns unprocessable_entity status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "includes missing field error messages" do
          expect(response.parsed_body["message"]).to include "Value can't be blank"
          expect(response.parsed_body["message"]).to include "Post must exist"
        end
      end

      context "with invalid data" do
        before do
          post "/api/v1/ratings", params: { rating: { value: 0, user_id: 99, post_id: 99 } }
        end

        it "returns unprocessable_entity status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "includes validation error messages" do
          expect(response.parsed_body["message"]).to include "Value must be greater than or equal to 1"
          expect(response.parsed_body["message"]).to include "Post must exist"
          expect(response.parsed_body["message"]).to include "User must exist"
        end
      end

      context "when user already rated the post" do
        before do
          create(:rating, user: user, post: first_post, value: 4)
          post "/api/v1/ratings", params: { rating: { value: 5, user_id: user.id, post_id: first_post.id } }
        end

        it "returns unprocessable_entity status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "includes a message that user can only vote once per post" do
          expect(response.parsed_body["message"]).to include "User - you can only vote once per post"
        end
      end
    end
  end

  describe "GET /api/v1/ratings/ranking" do
    let(:users) { create_list(:user, 3) }
    let(:posts) { create_list(:post, 3) }

    before do
      users
      posts
      create(:rating, post: posts[1], value: 4, user: users[1])
      create(:rating, post: posts[2], value: 3, user: users[2])
      create(:rating, post: posts[1], value: 3, user: users[0])
    end

    it "returns top posts by average rating" do
      get "/api/v1/ratings/ranking"

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["post_ranking"].first["id"]).to eq(posts[1].id)
    end
  end
end
