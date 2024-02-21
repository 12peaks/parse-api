class AddEventNumberToTriageEvents < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      CREATE SEQUENCE triage_events_event_number_seq START 1;
    SQL

    add_column :triage_events, :event_number, :integer, default: -> { "nextval('triage_events_event_number_seq')" }
  end

  def down
    remove_column :triage_events, :event_number
    execute <<-SQL
      DROP SEQUENCE IF EXISTS triage_events_event_number_seq;
    SQL
  end
end
