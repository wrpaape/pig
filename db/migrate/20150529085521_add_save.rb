class AddSave < ActiveRecord::Migration
  def change
    create_table :saves do |t|
      t.string :game_mode
      t.string :player_names
      t.integer :player_scores

      t.timestamps null: false
    end
  end
end
