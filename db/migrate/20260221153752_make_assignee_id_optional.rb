# db/migrate/xxxxxx_make_assignee_id_optional.rb
class MakeAssigneeIdOptional < ActiveRecord::Migration[8.1]
  def change
    change_column_null :bugs, :assignee_id, true
  end
end