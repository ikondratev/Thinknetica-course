class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :name
      t.string :url
      t.belongs_to :question, foreign_key: true

      t.timestamps
    end
  end
end
