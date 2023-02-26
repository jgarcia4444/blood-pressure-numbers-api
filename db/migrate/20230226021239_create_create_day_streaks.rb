class CreateCreateDayStreaks < ActiveRecord::Migration[7.0]
  def change
    create_table :day_streaks do |t|
      t.integer :days
      t.datetime :expires_at
      t.integer :user_id

      t.timestamps
    end
  end
end
