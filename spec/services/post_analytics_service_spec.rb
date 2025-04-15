require "rails_helper"

RSpec.describe PostAnalyticsService do
  let(:users) { create_list(:user, 5) }
  let(:posts) { create_list(:post, 5) }

  before do
    users
    posts
    create(:rating, post: posts[1], value: 4, user: users[1])
    create(:rating, post: posts[2], value: 3, user: users[2])
    create(:rating, post: posts[3], value: 2, user: users[3])
    create(:rating, post: posts[4], value: 1, user: users[4])
  end

  describe '.post_average_rating' do
    context 'when the post has ratings' do
      before do
        create(:rating, post: posts[1], value: 5, user: users[2])
      end

      it { expect(PostAnalyticsService.post_average_rating(posts[1].id)).to eq 4.5 }
    end

    context 'when the post has no ratings' do
      it { expect(PostAnalyticsService.post_average_rating(posts[0].id)).to eq 0.0 }
    end
  end

  describe ".post_ranking" do
    subject(:result) { described_class.post_ranking }

    it "returns the top 5 posts ordered by average rating" do
      expect(result.to_a.size).to be <= 5
      expect(result.to_a.first).to eq(posts[1])
    end

    it 'does not include posts with no ratings in the ranking' do
      expect(result.to_a).not_to include(posts[5])
    end
  end

  describe ".recurrent_ips" do
    subject(:result) { described_class.recurrent_ips }

    let(:unique_user) { create(:user, login: "unique@mail.com") }

    before { create(:post, user: unique_user, ip: "192.111.1.2") }

    it "returns only IPs with multiple authors" do
      expect(result.to_a.first.ip).to eq("111.11.1.1")
      expect(result).not_to include("192.111.1.1")
    end
  end
end
