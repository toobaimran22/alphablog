class ReplaceAdminWithRoleInUsers < ActiveRecord::Migration[8.0]
  def change
    def change
      remove_column :users, :admin, :boolean
      add_column :users, :role, :string, null: false, default: "writer"
    end
  end
end
