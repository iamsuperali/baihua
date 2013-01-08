class CreateLoginLogs < ActiveRecord::Migration
  def change
    create_table :login_logs do |t|

      t.timestamps
    end
  end
end
