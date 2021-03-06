class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account_name, null: false
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.references :country, null: false
      t.string :mobile, null: false, null: false
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.string :device_type
      t.string :device_token
      t.string :verification_token
      t.boolean :verified, default: false
      t.datetime :verification_token_sent_at

      t.timestamps
    end

    add_index :users, :country_id, name: 'index_users_on_country_id'
    add_index :users, :account_name, name: 'index_users_on_account_name', unique: true
    add_index :users, :mobile, name: 'index_users_on_mobile', unique: true
    add_index :users, :device_token, name: 'index_users_on_device_token', unique: true
  end
end
