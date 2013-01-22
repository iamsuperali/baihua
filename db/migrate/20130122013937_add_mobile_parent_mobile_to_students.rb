class AddMobileParentMobileToStudents < ActiveRecord::Migration
  def change
    add_column :students, :mobile, :string
    add_column :students, :parent_mobile, :string
  end
end
