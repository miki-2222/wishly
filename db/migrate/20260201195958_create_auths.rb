class CreateAuths < ActiveRecord::Migration[7.1]
  def change
    create_table :auths do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end

    add_index :auths, [:provider, :uid], unique: true
  end
end
