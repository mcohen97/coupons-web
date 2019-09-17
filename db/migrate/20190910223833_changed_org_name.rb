class ChangedOrgName < ActiveRecord::Migration[6.0]
  def change
    rename_column :organizations, :name, :organization_name
  end
end
