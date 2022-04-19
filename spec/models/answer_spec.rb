require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it_behaves_like 'votable'
    it_behaves_like 'commentable'
    it_behaves_like 'linkable'

    it { should belong_to :question }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
