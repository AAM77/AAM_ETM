class AddColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :telephone_num, :string
    add_column :users, :address, :string
  end
end
