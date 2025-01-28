class CreateSubmissions < ActiveRecord::Migration[7.2]
  def change
    create_table :submissions do |t|
      t.integer :sign_id
      t.integer :submitted_by
      t.integer :approved_by

      t.timestamps
    end

    add_foreign_key :submissions, :signs, column: :sign_id
    add_index :submissions, :sign_id

    add_foreign_key :submissions, :users, column: :submitted_by
    add_index :submissions, :submitted_by

    add_foreign_key :submissions, :users, column: :approved_by
    add_index :submissions, :approved_by
  end
end
