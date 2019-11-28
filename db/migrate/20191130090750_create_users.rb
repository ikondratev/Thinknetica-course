class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :u_name
      t.string :u_email

      t.timestamps
    end
  end
end
