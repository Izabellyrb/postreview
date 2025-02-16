require 'rails_helper'

RSpec.describe Api::V1::PostsController do
  describe "POST /api/v1/create" do
    context "when success" do
      before do
        post "/api/v1/posts",
        params: { post: { title: "MyTitle", body: "MyContent" }, user_login: "login@test.com" }
      end

      it { expect(response).to have_http_status(:created) }
      it { expect(response.parsed_body["message"]["user"]).to include "login@test.com" }
      it { expect(response.parsed_body["message"]["post"]).to include "MyTitle" }

    end

    context "when failure" do
      context "with data missing" do
        before do
          post "/api/v1/posts",
          params: { post: { title: "", body: "" }, user_login: "login@test.com" }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.parsed_body["message"]).to include "Title can't be blank" }
        it { expect(response.parsed_body["message"]).to include "Body can't be blank" }
      end

      context "with invalid formats" do
        context "when ip is invalid" do
          before do
            allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return("xx")

            post "/api/v1/posts",
            params: { post: { title: "MyTitle", body: "MyContent" }, user_login: "login@test.com" }
          end

          it { expect(response).to have_http_status(:unprocessable_entity) }
          it { expect(response.parsed_body["message"]).to include "Ip must be a valid IPv4 or IPv6 IP address" }
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
end
