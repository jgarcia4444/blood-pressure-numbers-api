class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.boolean :notifications
      t.integer :user_id

      t.timestamps
    end
  end
end