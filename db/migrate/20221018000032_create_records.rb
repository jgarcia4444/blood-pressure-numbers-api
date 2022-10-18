class CreateRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :records do |t|
      t.integer :user_id
      t.integer :systolic
      t.integer :diastolic
      t.boolean :right_arm_recorded
      t.text :notes

      t.timestamps
    end
  end
end
