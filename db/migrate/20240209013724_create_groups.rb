class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups, id: :uuid do |t|
      t.string :name
      t.text :description
      t.boolean :is_private, default: false
      t.boolean :is_visible, default: true
      t.string :url_slug
      t.references :team, null: false, foreign_key: { to_table: :teams }, type: :uuid

      t.timestamps
    end
  end
end
