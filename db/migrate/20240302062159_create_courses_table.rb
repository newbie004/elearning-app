class CreateCoursesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :courses, id: :uuid do |t|
      t.string :name
      t.timestamps
    end

    add_index :courses, :name, unique: true
  end
end
