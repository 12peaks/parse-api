class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts, id: :uuid do |t|
      t.text :content
      t.text :text_content
      t.boolean :is_pinned, default: false
      t.references :group, null: true, foreign_key: { to_table: :groups }, type: :uuid
      t.references :user, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
