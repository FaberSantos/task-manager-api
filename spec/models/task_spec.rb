require 'rails_helper'

RSpec.describe Task, type: :model do
#  pending "add some examples to (or delete) #{__FILE__}"

  let(:task) {build(:task)}

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:user_id) }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:done) }
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:deadline) }


  context 'when is new' do
    it { expect(task).not_to be_done }
  end

  
end
