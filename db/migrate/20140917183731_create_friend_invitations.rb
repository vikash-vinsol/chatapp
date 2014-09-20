class CreateFriendInvitations < ActiveRecord::Migration
  def change
    create_table :friend_invitations do |t|
      t.integer :inviter_id, null: false
      t.integer :invitee_id, null: false

      t.timestamps
    end
  end
end
