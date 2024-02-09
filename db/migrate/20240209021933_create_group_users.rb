class CreateGroupUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :group_users do |t|
      t.references :group, null: false, foreign_key: true, type: :uuid, index: true
      t.references :user, null: false, foreign_key: true, type: :uuid, index: true

      t.timestamps
    end
    add_index :group_users, [:group_id, :user_id], unique: true
  end
end
