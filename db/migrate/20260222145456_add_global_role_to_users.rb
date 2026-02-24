class AddGlobalRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :global_role, :integer, default: 0 
  end
end