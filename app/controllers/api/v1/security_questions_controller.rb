class Api::V1::SecurityQuestionsController < Api::V1::ApiController
  before_action :authorize_request

  def index
    questions = current_user.security_questions
    render json: questions, serailizer: SecurityQuestionSerializer, success: true, status: 200
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def security_question_params
    params.require(:security_question).permit(:question, :answer)
  end
end
