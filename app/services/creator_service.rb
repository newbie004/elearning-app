class CreatorService
  def initialize(params)
    @params = params
  end

  def call!
    # putting creation of course and tutors in a transaction
    # Because if any of the tutor creation fails, we want to rollback the course creation as well
    ActiveRecord::Base.transaction do
      course = create_course
      tutors = create_tutors(course)
      if course.valid? && tutors.all?(&:valid?)
        OpenStruct.new(success?: true, course: course, tutors: tutors)
      else
        OpenStruct.new(success?: false, errors: course.errors.merge(tutors.map(&:errors)))
      end
    end
  rescue StandardError => e
    OpenStruct.new(success?: false, errors: { base: [e.message] })
  end

  private

  def create_course
    course = Course.find_by(name: @params[:course_name])
    if course.present?
      raise StandardError, "Course with name `#{course.name}` already exists"
    else
      Course.create(name: @params[:course_name])
    end
  end

  def create_tutors(course)
    @params[:tutors].map do |tutor_params|
      tutor = Tutor.find_by(name: tutor_params[:name])
      if tutor.present?
        raise StandardError, "Tutor with name `#{tutor.name}` already exists"
      else
        course.tutors.create(tutor_params)
      end
    end
  end
end
