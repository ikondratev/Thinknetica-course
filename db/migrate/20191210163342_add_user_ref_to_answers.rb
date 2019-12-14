class AddUserRefToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :user, null: false, foreign_key: true
  end
end
