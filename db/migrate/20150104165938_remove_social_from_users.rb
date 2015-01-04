class RemoveSocialFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, name: 'index_users_for_socialize'
    remove_column :users, :social
  end
end
