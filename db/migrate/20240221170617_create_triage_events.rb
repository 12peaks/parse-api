class CreateTriageEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :triage_events, id: :uuid do |t|
      t.text :description
      t.string :severity
      t.string :status
      t.references :user, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.uuid :owner_id
      t.uuid :team_id

      t.timestamps
    end
  end
end
