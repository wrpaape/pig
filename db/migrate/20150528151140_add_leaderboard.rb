class AddLeaderboard < ActiveRecord::Migration
  def change
    create_table :leaderboards do |t|
      t.string :game_mode
      t.string :player_name
      t.integer :num_played
      t.integer :num_wins

      t.timestamps null: false
    end
  end
end
