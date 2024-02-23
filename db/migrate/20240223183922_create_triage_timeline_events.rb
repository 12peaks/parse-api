class CreateTriageTimelineEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :triage_timeline_events, id: :uuid do |t|
      t.text :old_value
      t.text :new_value
      t.references :triage_event, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.text :field

      t.timestamps
    end
  end
end
