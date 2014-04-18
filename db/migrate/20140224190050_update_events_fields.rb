class UpdateEventsFields < ActiveRecord::Migration
  def change
    # rename_column :events, :event_begin_date, :begin_date
    # rename_column :events, :event_end_date, :end_date

    change_column_null :events, :begin_date, false
    change_column_null :events, :end_date, false
    change_column_null :events, :group_id, false
    change_column_null :events, :name, false
  end
end
