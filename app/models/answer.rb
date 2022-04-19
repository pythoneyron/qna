class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  after_commit :send_notification, on: :create

  def send_notification
    NotificationJob.perform_later(self)
  end
end
