require 'dry/schema'

CourseParamsValidator = Dry::Schema.Params do
  required(:course_name).filled(:string)
  required(:tutors).filled { each(:hash).schema { required(:name).filled(:string) } }
end
