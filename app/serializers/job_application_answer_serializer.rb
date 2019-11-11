class JobApplicationAnswerSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :question_id, :answer
end