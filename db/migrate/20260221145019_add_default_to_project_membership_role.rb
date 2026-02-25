class AddDefaultToProjectMembershipRole < ActiveRecord::Migration[8.1]
  def change
    change_column_default :project_memberships, :role, 2
  end
end
