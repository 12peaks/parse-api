class CreatePollOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :poll_options, id: :uuid do |t|
      t.text :text
      t.references :poll, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
