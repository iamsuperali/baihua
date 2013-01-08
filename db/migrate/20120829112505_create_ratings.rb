class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.string :name
      t.integer :upper_limit
      t.integer :lower_limit

      t.timestamps
    end
  end
end
