class SecurityQuestionSerializer < ActiveModel::Serializer
	attributes :id, :uuid, :question, :answer
end