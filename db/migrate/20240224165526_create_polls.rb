class CreatePolls < ActiveRecord::Migration[7.1]
  def change
    create_table :polls, id: :uuid do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :group, null: true, foreign_key: true, type: :uuid
      t.references :team, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
