class CreatePendingSocials < ActiveRecord::Migration
  def change
    create_table :pending_socials do |t|
      t.references :user, null: false
      t.references :content, null: false

      t.timestamps
    end
  end
end