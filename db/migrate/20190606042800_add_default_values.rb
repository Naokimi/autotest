class AddDefaultValues < ActiveRecord::Migration[5.2]
  def change
    change_column :answers, :is_correct, :boolean, default: false
    change_column :exams, :verified, :boolean, default: false
    change_column :questions, :score, :integer, default: 1
  end
end
