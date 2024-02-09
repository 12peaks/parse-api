class AddCurrentTeamToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :current_team_id, :uuid
  end
end
