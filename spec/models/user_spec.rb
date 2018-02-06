require 'rails_helper'

RSpec.describe User, type: :model do

  # before { @user = FactoryGirl.build(:user) }
  #

  # it { expect(@user).to respond_to(:name) }
  # it { expect(@user).to respond_to(:password_confirmation) }
  # it { expect(@user).to be_valid }
  #
  #
  # subject = User.new

  let(:user) {build(:user)}


  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value('fff@fff.com').for(:email) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }


  describe '#info' do

    it 'returns email,  created_at and a Token' do
      user.save!
      allow(Devise).to receive(:friendly_token).and_return('ABC123')
      expect(user.info).to eq("#{user.email} - #{user.created_at} - #{Devise.friendly_token}")
    end

  end


  describe '#generate_authentication_token!' do

    it 'generates unique auth token' do
     # user.save!
      allow(Devise).to receive(:friendly_token).and_return('ABC123')
      user.generate_authentication_token!

      expect(user.auth_token).to eq("ABC123")
    end

    it 'generates another token when current token has been taken' do
      allow(Devise).to receive(:friendly_token).and_return('abc123token','abc123token', 'abcXYZ1234')
      existing_user = create(:user)
      user.generate_authentication_token!

      expect(user.auth_token).not_to eq(existing_user.auth_token)
    end

  end

end
