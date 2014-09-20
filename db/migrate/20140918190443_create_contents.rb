class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.text :description
      t.references :user, index: true
      t.string :attachment_file_name
      t.integer :attachment_file_size
      t.string :attachment_content_type
      t.datetime :attachment_update_at
      t.integer :timer
      t.integer :receiver_count, default: 0

      t.timestamps
    end
  end
end
