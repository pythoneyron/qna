class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_question, only: %i[create new]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @answers = Answer.all
  end

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def edit
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.author = current_user
    if @answer.save
      redirect_to question_path(@question), notice: 'Your answer successfully created.'
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
    redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted.'
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
