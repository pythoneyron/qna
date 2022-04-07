require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it_behaves_like 'votable'

    it { should belong_to :question }
    it { should have_many(:links).dependent(:destroy) }
    it { should belong_to(:author).class_name('User') }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for :links }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
