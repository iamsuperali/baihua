class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :num,:null=>false
      t.integer :floor,:null=>false

      t.timestamps
    end
  end
end
