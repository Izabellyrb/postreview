require "rails_helper"

RSpec.describe PostCreatorService do
  describe ".call" do
    subject(:result) { described_class.new(post_params, user_login, ip).call }

    let(:post_params) { { title: "MyTitle", body: "MyContent" } }
    let(:user_login) { "mylogin@test.com" }
    let(:ip) { "111.11.1.1" }

    context "when success" do
      before { result }

      context "when user is new" do
        it { expect(Post.count).to eq(1) }
        it { expect(User.count).to eq(1) }
      end

      context "when user has already been created" do
        before { described_class.new({ title: "Another Title", body: "Another Body" }, user_login, ip).call }

        it { expect(Post.count).to eq(2) }
        it { expect(User.count).to eq(1) }
      end
    end

    context "when failure" do
      context "when any data is missing" do
        let(:post_params) { { title: "", body: "MyContent" } }

        it { expect(Post.count).to eq(0) }
        it { expect(User.count).to eq(0) }
      end

      context "when something unexpected happens" do
        before do
          allow(Post).to receive(:create!).and_raise(StandardError, "Unexpected error")
        end

        it { expect(result[:message]).to include("Unexpected error") }
        it { expect(Post.count).to eq(0) }
        it { expect(User.count).to eq(0) }
      end
    end
  end
end
