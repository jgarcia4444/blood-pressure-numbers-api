class AddCodeVerifiedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :code_verified, :boolean, default: false
  end
end
