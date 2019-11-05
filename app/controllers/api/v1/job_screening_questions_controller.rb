class Api::V1::JobScreeningQuestionsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_question, only: [:destroy]

  def destroy
    if @screen_questions.destroy
      render json: {success: true, message: "Deleted", status: 200} 
    end
  end

	private

  def find_question
    @screen_questions = JobScreeningQuestion.where(uuid: params[:id]).or(JobScreeningQuestion.where(id: params[:id])).first
    render_error("Not found", 404) unless @screen_questions
  end

end
