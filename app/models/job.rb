class Job < ApplicationRecord
	has_many :job_screening_questions
	has_many :job_qualifictions
end
