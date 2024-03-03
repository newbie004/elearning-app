require 'rails_helper'

RSpec.describe 'Courses API', type: :request do
  describe 'GET /courses/fetch' do
    it 'returns all courses with associated tutors' do
      course1 = create(:course, name: 'Course 1')
      course2 = create(:course, name: 'Course 2')
      tutor1 = create(:tutor, name: 'Tutor 1', course: course1)
      tutor2 = create(:tutor, name: 'Tutor 2', course: course2)

      get '/courses/fetch'

      expect(response).to have_http_status(:ok)

      courses_with_tutors = JSON.parse(response.body)

      expect(courses_with_tutors.count).to eq(2)

      expect(courses_with_tutors[0]['name']).to eq('Course 1')
      expect(courses_with_tutors[0]['tutors'].count).to eq(1)
      expect(courses_with_tutors[0]['tutors'][0]['name']).to eq('Tutor 1')

      expect(courses_with_tutors[1]['name']).to eq('Course 2')
      expect(courses_with_tutors[1]['tutors'].count).to eq(1)
      expect(courses_with_tutors[1]['tutors'][0]['name']).to eq('Tutor 2')
    end
  end
end
