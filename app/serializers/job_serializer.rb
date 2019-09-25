class JobSerializer < ActiveModel::Serializer
  attributes :id
  attributes :job_title
  attributes :job_visibility
  attributes :created_at
end
