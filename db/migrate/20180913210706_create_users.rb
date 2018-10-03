class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string  :uid
      t.string  :provider
      t.string  :first_name
      t.string  :last_name
      t.string  :telephone_num
      t.string  :address
      t.string  :email
      t.string  :username
      t.string  :password_digest
      t.integer :total_points, default: 0

      t.timestamps
    end
  end
end
