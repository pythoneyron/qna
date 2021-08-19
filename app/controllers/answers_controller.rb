class AnswersController < ApplicationController
  before_action :answer, only: %i[edit update destroy]
  before_action :question, only: %i[create new]
  before_action :authenticate_user!

  def edit
  end

  def create
    @answer = question.answers.create(answer_params)
    answer.author = current_user
    if answer.save
      redirect_to answer.question, notice: 'Your answer successfully created.'
    else
      redirect_to answer.question, notice: "Your answer can't be blank."
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to answer
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      redirect_to question_path(answer.question), notice: 'Your answer successfully deleted.'
    else
      redirect_to question_path(answer.question), notice: 'You are not the author'
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body)
  end

end
