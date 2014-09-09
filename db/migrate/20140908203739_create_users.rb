class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account_name, null: false
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.references :country, null: false
      t.string :mobile, null: false, null: false
      t.string    :image_file_name
      t.string    :image_content_type
      t.integer   :image_file_size
      t.datetime  :image_updated_at
      t.string :device_type
      t.string :device_token
      t.string :verification_token
      t.boolean :verified
      t.boolean :verification_expired

      t.timestamps
    end
  end
end
