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
  it { is_expected.to allow_value("fff@fff.com").for(:email) }



end
