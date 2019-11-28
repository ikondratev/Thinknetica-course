class AddUserRefToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :user_id, :integer
  end
end
