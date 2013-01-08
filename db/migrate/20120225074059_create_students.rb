class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :num
      t.string :name
      t.boolean :sex
      t.date :enter_tag
      t.integer :state

      t.timestamps
    end
  end
end
