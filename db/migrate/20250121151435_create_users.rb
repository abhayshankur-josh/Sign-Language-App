class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.string :password
      t.integer :role_id
      t.timestamps
    end

    add_foreign_key :users, :roles, column: :role_id
    add_index :users, :role_id
  end
end
