require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }
  let(:author) { create(:user) }

  describe  '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it "calls Services::FindForOauth" do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe 'The user' do
    let(:question) { create(:question, author: author) }

    context '#author_of?' do
      it 'is an author' do
        expect(author).to be_author_of(question)
      end

      it 'is not an author' do
        expect(user).to_not be_author_of(question)
      end
    end

    context '#subscribed?' do
      let!(:subscription) { create(:subscription, question: question, user: author) }

      it 'is an subscriber' do
        expect(author).to be_subscribed(question)
      end

      it 'is not subscriber' do
        expect(user).to_not be_subscribed(question)
      end
    end
  end
end