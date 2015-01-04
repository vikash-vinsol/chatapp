class AddVerifiedIndexOnUsers < ActiveRecord::Migration
  def change
    add_index :users, :verified
  end
end
