class MakeCreatorIdNullable < ActiveRecord::Migration[8.1]
  def change
    change_column_null :projects, :creator_id, true
  end
end
