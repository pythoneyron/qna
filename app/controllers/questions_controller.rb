class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_subsription, only: [:show, :edit]
  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @best_answer = question.best_answer
    @other_answers = question.answers.where.not(id: question.best_answer)
    gon.push({question_id: question.id})
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_reward
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if authorize! :update, question
  end

  def destroy
    question.destroy if authorize! :destroy, question
    question.destroy if authorize! :update, question
    redirect_to questions_path
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def answer
    @answer ||= Answer.new
    @answer.links.new

    @answer
  end

  helper_method :question, :answer

  def question_params
    params.require(:question).permit(
      :title,
      :body, files: [],
      links_attributes: [:name, :url, :_destroy, :id],
      reward_attributes: [:name, :image]
    )
  end

  def find_subsription
    @subscription = question.subscriptions.find_by(user: current_user)
  end

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast(
      'questions_channel',
      ApplicationController.render(
        partial: 'questions/question_channel',
        locals: { question: @question }
      )
    )
  end
end
