require 'rails_helper'

RSpec.describe Api::V1::PostsController do
  describe "POST /api/v1/create" do
    context "when success" do
      before do
        post "/api/v1/posts",
        params: { post: { title: "MyTitle", body: "MyContent" }, user_login: "login@test.com" }
      end

      it { expect(response).to have_http_status(:created) }
      it { expect(response.parsed_body[:message][:author]).to eq "login@test.com" }
      it { expect(response.parsed_body[:message][:title]).to eq "MyTitle" }
    end

    context "when failure" do
      context "with data missing" do
        before do
          post "/api/v1/posts",
          params: { post: { title: "", body: "" }, user_login: "login@test.com" }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.parsed_body[:message]).to include "Title can't be blank" }
        it { expect(response.parsed_body[:message]).to include "Body can't be blank" }
      end

      context "with invalid formats" do
        context "when ip is invalid" do
          before do
            allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return("xx")

            post "/api/v1/posts",
            params: { post: { title: "MyTitle", body: "MyContent" }, user_login: "login@test.com" }
          end

          it { expect(response).to have_http_status(:unprocessable_entity) }
          it { expect(response.parsed_body[:message]).to include "Ip must be a valid IPv4 or IPv6 IP address" }
        end

        context "when login is invalid" do
          before do
            post "/api/v1/posts", params: { post: { title: "MyTitle", body: "MyContent" }, user_login: "test_1" }
          end

          it { expect(response).to have_http_status(:unprocessable_entity) }
          it { expect(response.body).to include "Login must be a valid email address (e.g., user@example.com)" }
        end
      end
    end
  end

  describe "GET /api/v1/posts/recurrent_ips" do
    let(:user1) { create(:user, login: 'user1@mail.com') }
    let(:user2) { create(:user, login: 'user2@mail.com') }

    before do
      create(:post, user: user1, ip: "192.111.1.1")
      create(:post, user: user2, ip: "192.111.1.1")
    end

    it "returns list of duplicated IPs and authors" do
      get "/api/v1/posts/recurrent_ips"

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body[:recurrent_ips].size).to eq(1)
      expect(response.parsed_body[:recurrent_ips].first[:ip]).to eq("192.111.1.1")
      expect(response.parsed_body[:recurrent_ips].first[:logins]).to include("user1@mail.com", "user2@mail.com")
    end
  end
end
