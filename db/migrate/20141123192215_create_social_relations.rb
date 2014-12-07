class CreateSocialRelations < ActiveRecord::Migration
  def change
    create_table :social_relations do |t|
      t.integer :user_id, null: false, unique: true
      t.integer :socialize_with_id, null: false, unique: true
      t.timestamps
    end

    add_index :social_relations, :user_id
  end
end
