class AddSocialParametersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :social, :boolean, default: false, null: false
    add_column :users, :socialized, :boolean, default: false, null: false
    add_index :users, [:verified, :social, :socialized], name: 'index_users_for_socialize'
  end
end
