require 'rails_helper'

RSpec.describe User do
  describe "validations" do
    it { is_expected.to validate_presence_of(:login) }

    context "when login format is not valid" do
      subject(:user) { build(:user, login: "test@") }

      it { expect(user).not_to be_valid }
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:posts) }
    it { is_expected.to have_many(:ratings) }
  end
end
