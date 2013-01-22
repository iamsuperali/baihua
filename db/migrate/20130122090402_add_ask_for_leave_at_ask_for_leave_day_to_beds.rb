class AddAskForLeaveAtAskForLeaveDayToBeds < ActiveRecord::Migration
  def change
    add_column :beds,:ask_for_leave_begin,:date
    add_column :beds,:ask_for_leave_end,:date
  end
end
