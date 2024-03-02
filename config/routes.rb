Rails.application.routes.draw do
  Rails.application.routes.draw do
    # writing custom route in order to have readable url
    post '/course/create', to: 'courses#create_with_tutors'
    get '/courses/fetch', to: 'courses#fetch_courses_with_tutors'
  end
end
