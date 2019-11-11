class JobApplicationAnswerSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :job_application_id, :question_id, :answer
end