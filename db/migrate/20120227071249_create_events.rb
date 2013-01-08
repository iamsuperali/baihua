class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :student
      t.integer :rule_type

      t.timestamps
    end
    add_index :events, :student_id
  end
end
