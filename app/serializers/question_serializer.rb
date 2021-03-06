class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  has_many :answers
  belongs_to :author, class_name: 'User', foreign_key: :user_id

  def short_title
    object.title.truncate(7)
  end
end
