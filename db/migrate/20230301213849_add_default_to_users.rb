class AddDefaultToUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :code_verified
    add_column :users, :code_verified, :string, default: false
  end
end
