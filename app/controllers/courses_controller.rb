class CoursesController < ApplicationController

  # As We would not be submitting any forms or making requests via Javascript,
  # So for now skipping CSRF protection

  skip_before_action :verify_authenticity_token, only: :create_with_tutors

  def create_with_tutors
    validated_params = validate_params(params)
    if validated_params.success?
      @course_params = validated_params.to_h
      result = CreatorService.new(@course_params).call!
      if result.success?
        render json: { success: true, course: result.course, tutors: result.tutors }, status: :created
      else
        render json: { errors: result.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: validated_params.errors }, status: :unprocessable_entity
    end
  end

  private

  def validate_params(params)
    CourseParamsValidator.call(params.to_unsafe_hash)
  end

end
