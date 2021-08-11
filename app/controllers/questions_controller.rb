class QuestionsController < ApplicationController
  before_action :set_questions, only: [:show, :edit]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def edit
  end

  private

  def set_questions
    @question = Question.find(params[:id])
  end
end
