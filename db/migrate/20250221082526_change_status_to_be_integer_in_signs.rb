class ChangeStatusToBeIntegerInSigns < ActiveRecord::Migration[7.2]
  def change
    change_column :signs, :status, :integer
  end
end
