class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @best_answer = question.best_answer
    @other_answers = question.answers.where.not(id: question.best_answer)
  end

  def new
    @question = current_user.questions.new
    @question.links.new
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
    question.update(question_params)
  end

  def destroy
    question.destroy if current_user.author?(question)
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
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url])
  end
end
