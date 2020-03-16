class AddColumnsToUser < ActiveRecord::Migration[6.0]
  change_table :users do |t|
    t.string :confirmation_token
    t.datetime :confirmed_at
    t.datetime :confirmation_sent_at
    t.string   :unconfirmed_email
  end
end
