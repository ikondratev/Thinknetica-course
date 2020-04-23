class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true, null: false
      t.references :question, foreign_key: true, null: false
    end
  end
end
