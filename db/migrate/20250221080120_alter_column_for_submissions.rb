class AlterColumnForSubmissions < ActiveRecord::Migration[7.2]
  def up
    change_table(:submissions) do |t|
      t.rename(:submitted_by, :submitted_by_id)
      t.rename(:approved_by, :approved_by_id)
    end
  end

  def down
    change_table(:submissions) do |t|
      t.rename(:submitted_by_id, :submitted_by)
      t.rename(:approved_by_id, :approved_by)
    end
  end
end
