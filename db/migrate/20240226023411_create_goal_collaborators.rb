class CreateGoalCollaborators < ActiveRecord::Migration[7.1]
  def change
    create_table :goal_collaborators, id: :uuid do |t|
      t.references :team, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :goal, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
