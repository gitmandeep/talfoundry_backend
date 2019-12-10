class JobQualificationSerializer < ActiveModel::Serializer
  attributes :id
  attributes :uuid
  attributes :freelancer_type
  attributes :job_success_score
  attributes :billed_on_talfoundry
  attributes :english_level
  attributes :rising_talent
  attributes :qualification_group
  attributes :location
  attributes :certificate_category
end
