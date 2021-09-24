class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :answer, only: %i[edit update destroy]
  before_action :question, only: %i[create new]
  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    @answer = question.answers.new(answer_params)
    answer.author = current_user
    answer.save

    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json{ render json: @answer.errors.full_messages, status: :unprocessable_entity}
      end
    end
  end

  def update
    answer.update(answer_params)
    @question = answer.question
  end

  def destroy
     if authorize! :destroy, answer
       answer.destroy
       flash.now[:alert] = 'Your answer deleted'
       set_question
     end
  end

  def update
    if authorize! :update, answer
      answer.update(answer_params)
      set_question
    end
  end

  def mark_as_best
    set_question
    if authorize! :mark_as_best, answer
      question.set_best_answer(answer)
    end
	end

  private

  def publish_answer
    return if answer.errors.any?
    ActionCable.server.broadcast("answers/#{params[:question_id]}",
      ApplicationController.render(
        partial: 'answers/answer_channel',
        locals: { question: answer.question, answer: answer, current_user: current_user }
      )
    )
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy, :id])
  end

end
