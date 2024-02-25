class CreateGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :goals, id: :uuid do |t|
      t.references :team, null: false, foreign_key: true, type: :uuid
      t.text :name
      t.text :description
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :format
      t.datetime :start_date
      t.datetime :end_date
      t.float :initial_value
      t.float :target_value

      t.timestamps
    end
  end
end
