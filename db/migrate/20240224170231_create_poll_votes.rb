class CreatePollVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :poll_votes, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :poll_option, null: false, foreign_key: true, type: :uuid
      t.references :poll, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
