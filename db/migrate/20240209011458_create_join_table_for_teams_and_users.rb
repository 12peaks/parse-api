class CreateJoinTableForTeamsAndUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :teams_users, id: false do |t|
      t.uuid :team_id, null: false
      t.uuid :user_id, null: false
      t.index :team_id
      t.index :user_id
    end
  end
end
