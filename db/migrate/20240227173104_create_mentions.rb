class CreateMentions < ActiveRecord::Migration[7.1]
  def change
    create_table :mentions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :post, null: false, foreign_key: true, type: :uuid
      t.references :group, null: true, foreign_key: true, type: :uuid
      t.references :comment, null: true, foreign_key: true, type: :uuid
      t.uuid :mentioned_user_id, null: false

      t.timestamps
    end
  end
end
