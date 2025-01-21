class CreateSigns < ActiveRecord::Migration[7.2]
  def change
    create_table :signs do |t|
      t.string :title
      t.text :description
      t.string :status
      t.integer :video_id

      t.timestamps
    end

    add_foreign_key :signs, :videos, column: :video_id
    add_index :signs, :video_id
  end
end
