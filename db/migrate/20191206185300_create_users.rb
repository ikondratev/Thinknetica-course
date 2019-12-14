class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, &:timestamps
  end
end
