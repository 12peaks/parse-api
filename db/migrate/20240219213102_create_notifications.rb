class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :status
      t.text :text
      t.text :image_url
      t.string :target_model
      t.uuid :target_model_id
      t.references :user, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :group, null: true, foreign_key: { to_table: :groups }, type: :uuid
      t.references :post, null: true, foreign_key: { to_table: :posts }, type: :uuid
      t.uuid :notify_user_id

      t.timestamps
    end
  end
end
