class AnswersController < ApplicationController
  before_action :answer, only: %i[edit update destroy]
  before_action :question, only: %i[create new]
  before_action :authenticate_user!

  def edit
  end

  def create
    @answer = question.answers.create(answer_params)
    answer.author = current_user
    answer.save
  end

  def update
    answer.update(answer_params)
    @question = answer.question
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      message = { notice: 'Your answer successfully deleted.' }
    else
      message = { notice: 'You are not the author' }
    end

    respond_to do |format|
      format.json do
        render json: message.to_json
      end
    end
  end

  def mark_as_best
    answer = Answer.find(params[:answer_id])
    answer.question.update(best_answer_id: answer.id)

    respond_to do |format|
      format.json do
        render json: 'Success'
      end
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
