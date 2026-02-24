class AddForeignKeyConstraintsToUsers < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :bugs, :users, column: :reporter_id if foreign_key_exists?(:bugs, :users, column: :reporter_id)
    remove_foreign_key :bugs, :users, column: :assignee_id if foreign_key_exists?(:bugs, :users, column: :assignee_id)
    remove_foreign_key :projects, :users, column: :creator_id if foreign_key_exists?(:projects, :users, column: :creator_id)
    remove_foreign_key :project_memberships, :users if foreign_key_exists?(:project_memberships, :users)
    
    add_foreign_key :bugs, :users, column: :reporter_id, on_delete: :cascade
    add_foreign_key :bugs, :users, column: :assignee_id, on_delete: :nullify
    add_foreign_key :projects, :users, column: :creator_id, on_delete: :nullify
    add_foreign_key :project_memberships, :users, on_delete: :cascade
  end
end