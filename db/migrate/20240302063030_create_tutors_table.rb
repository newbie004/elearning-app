class CreateTutorsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :tutors, id: :uuid do |t|
      t.string :name
      t.references :course, type: :uuid, null: false, foreign_key: true
      t.timestamps
    end
    add_index :tutors, :name, unique: true
  end
end
