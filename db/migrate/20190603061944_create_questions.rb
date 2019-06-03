class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.references :exam, foreign_key: true
      t.integer :score
      t.string :correct_answer
      t.float :origin_x
      t.float :origin_y
      t.float :width
      t.float :height

      t.timestamps
    end
  end
end
