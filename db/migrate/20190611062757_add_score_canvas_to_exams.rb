class AddScoreCanvasToExams < ActiveRecord::Migration[5.2]
  def change
    add_column :exams, :score_origin_x, :float
    add_column :exams, :score_origin_y, :float
    add_column :exams, :score_width, :float
    add_column :exams, :score_height, :float
  end
end
