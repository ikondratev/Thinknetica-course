class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :count, null: false, default: 0
      t.belongs_to :user, foreign_key: true
      t.belongs_to :voteable, polymorphic: true

      t.timestamps
    end
  end
end
