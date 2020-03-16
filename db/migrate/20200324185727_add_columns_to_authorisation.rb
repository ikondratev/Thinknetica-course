class AddColumnsToAuthorisation < ActiveRecord::Migration[6.0]
  change_table :authorizations do |t|
    t.datetime :confirmed_at
  end
end
