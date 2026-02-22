# db/migrate/xxxxxx_add_global_role_to_users.rb
class AddGlobalRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :global_role, :integer, default: 0  # 0=employee, 1=admin
  end
end