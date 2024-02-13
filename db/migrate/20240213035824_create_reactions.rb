class CreateReactions < ActiveRecord::Migration[7.1]
  def change
    create_table :reactions, id: :uuid do |t|
      t.string :emoji_text
      t.string :emoji_code
      t.references :user, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :post, null: false, foreign_key: { to_table: :posts }, type: :uuid

      t.timestamps
    end
  end
end
