class CreateGoalUpdates < ActiveRecord::Migration[7.1]
  def change
    create_table :goal_updates, id: :uuid do |t|
      t.references :goal, null: false, foreign_key: true, type: :uuid
      t.references :team, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.text :note
      t.float :value
      t.text :status

      t.timestamps
    end
  end
end
