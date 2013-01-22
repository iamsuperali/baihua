class AddStudentIdToBeds < ActiveRecord::Migration
  def change
    add_column :students, :bed_id, :integer
  end
end
