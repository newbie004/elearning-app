class Course < ApplicationRecord

  # adding association for course can have multiple tutors
  has_many :tutors, dependent: :destroy

  # adding validation for course name
  validates :name, presence: true
end
