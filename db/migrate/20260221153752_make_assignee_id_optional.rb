class MakeAssigneeIdOptional < ActiveRecord::Migration[8.1]
  def change
    change_column_null :bugs, :assignee_id, true
  end
end
