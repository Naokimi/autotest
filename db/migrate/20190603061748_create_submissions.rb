class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.string :image
      t.integer :student_number
      t.references :exam, foreign_key: true

      t.timestamps
    end
  end
end
