class CreateBeds < ActiveRecord::Migration
  def change
    create_table :beds do |t|
      t.integer :room_id,:null=>false
      t.string :num,:null=>false
      t.integer :status

      t.timestamps
    end
  end
end
