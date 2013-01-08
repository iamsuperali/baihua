class ChangeStudentAddClassGrade < ActiveRecord::Migration
  def up
    add_column :students, :class_num, :integer
    add_column :students, :grade,:integer
    change_column :students, :sex, :integer
  end

  def down
    remove_column :students, :class_num
    remove_column :students, :grade
    change_column :students, :sex, :boolean
  end
end
