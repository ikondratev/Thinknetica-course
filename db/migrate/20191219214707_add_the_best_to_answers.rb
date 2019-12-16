class AddTheBestToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :the_best, :boolean, null: false, default: false
  end
end
