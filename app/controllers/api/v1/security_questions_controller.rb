class Api::V1::SecurityQuestionsController < Api::V1::ApiController
	before_action :authorize_request

	def index
	end

	def create
		security_question = @current_user.security_questions.build(security_question_params)
		if security_question.save
      render json: {success: true, message: "Created", status: 200} 	
		else
			render_error("Something went wrong....!", 404)
		end
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
