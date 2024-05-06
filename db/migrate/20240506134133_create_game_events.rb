class CreateGameEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :game_events do |t|
      t.integer :game_id
      t.integer :user_id
      t.datetime :occurred_at

      t.timestamps
    end

    add_column :users, :total_games_played, :integer, default: 0
  end
end
