RSpec.describe CoursesController, type: :controller do

  def json_response
    JSON.parse(response.body) if response.body.present?
  end

  describe 'POST #create_with_tutors' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          course_name: 'Introduction to Rails',
          tutors: [
            { name: 'John Doe' },
            { name: 'Jane Smith' }
          ]
        }
      end

      it 'creates a course with associated tutors' do
        expect do
          post :create_with_tutors, params: valid_params
        end.to change(Course, :count).by(1)
                                     .and change(Tutor, :count).by(2)
        expect(response).to have_http_status(:created)
        expect(json_response['success']).to be true
        expect(json_response['course']['name']).to eq('Introduction to Rails')
        expect(json_response['tutors'].size).to eq(2)
      end
    end

    context 'when course already exists' do
      let!(:existing_course) { create(:course, name: 'Existing Course') }
      let(:params_with_existing_course) do
        {
          course_name: existing_course.name,
          tutors: [{ name: 'John Doe' }]
        }
      end

      it 'returns unprocessable entity status' do
        post :create_with_tutors, params: params_with_existing_course
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']['base']).to include("Course with name #{existing_course.name} already exists")
      end
    end

    context 'when tutor already exists' do
      let!(:existing_tutor) { create(:tutor, name: 'Existing Tutor', course: create(:course)) }
      let(:params_with_existing_tutor) do
        {
          course_name: 'New Course',
          tutors: [{ name: existing_tutor.name }]
        }
      end

      it 'returns unprocessable entity status' do
        post :create_with_tutors, params: params_with_existing_tutor
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']['base']).to include("Tutor with name #{existing_tutor.name} already exists")

      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        { course_name: '' } # Invalid because course name is required
      end

      it 'returns unprocessable entity status' do
        post :create_with_tutors, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include(
                                             {
                                               "text" => "must be filled",
                                               "path" => ["course_name"],
                                               "predicate" => "filled?",
                                               "args" => [],
                                               "input" => "",
                                               "meta" => {}
                                             }
                                           )
      end
    end
  end
end
