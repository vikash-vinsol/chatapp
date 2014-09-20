class CreateContentReceivers < ActiveRecord::Migration
  def change
    create_table :content_receivers do |t|
      t.integer :receiver_id
      t.integer :content_id
      t.string :type

      t.timestamps
    end
  end
end
