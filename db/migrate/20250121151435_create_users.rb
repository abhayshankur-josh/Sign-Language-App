class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :full_name
      t.integer :role_id, default: 01
      t.string :jti
      t.boolean :active, default: true
      t.timestamps
    end

    add_foreign_key :users, :roles, column: :role_id
    add_index :users, :role_id
    add_index :users, :jti
  end
end
