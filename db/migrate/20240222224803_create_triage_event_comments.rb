class CreateTriageEventComments < ActiveRecord::Migration[7.1]
  def change
    create_table :triage_event_comments, id: :uuid do |t|
      t.text :text
      t.references :triage_event, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
