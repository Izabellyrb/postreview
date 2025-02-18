require "rails_helper"

RSpec.describe RatingCreatorService do
  describe "#call" do
    subject(:result) { described_class.new(params).call }

    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }
    let(:params) { { post_id: post.id, user_id: user.id, value: 5 } }

    context "when success" do
      before { result }

      context "when rating is successfully created" do
        it { expect(Rating.count).to eq(1) }
        it { expect(result[:message][:average_rating]).to eq(5) }
      end
    end

    context "when failure" do
      context "when any data is missing" do
        before { result }

        let(:params) { { post_id: post.id, user_id: user.id, value: nil } }

        it { expect(Rating.count).to eq(0) }
      end

      context "when something unexpected happens" do
        before do
          allow(Rating).to receive(:create!).and_raise(StandardError, "Unexpected error")
        end

        it { expect(result[:message]).to include("Unexpected error") }
        it { expect(Rating.count).to eq(0) }
      end
    end
  end
end
