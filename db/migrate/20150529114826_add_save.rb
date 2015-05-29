class AddSave < ActiveRecord::Migration
  def change
    create_table :saves do |t|
      t.string :game_mode
      t.string :player_names
      t.string :player_scores
      t.string :load_code

      t.timestamps null: false
    end
  end
end
