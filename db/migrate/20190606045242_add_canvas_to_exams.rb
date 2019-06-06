class AddCanvasToExams < ActiveRecord::Migration[5.2]
  def change
    add_column :exams, :origin_x, :float
    add_column :exams, :origin_y, :float
    add_column :exams, :width, :float
    add_column :exams, :height, :float
  end
end
