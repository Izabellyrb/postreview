require 'rails_helper'

RSpec.describe Post do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:ip) }

    context "when ip format is not valid" do
      subject(:post) { build(:post, ip: "34.") }

      it { expect(post).not_to be_valid }
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:ratings) }
  end
end
