class AddRemarkToEvents < ActiveRecord::Migration
  def change
    add_column :events, :remark, :string
  end
end
