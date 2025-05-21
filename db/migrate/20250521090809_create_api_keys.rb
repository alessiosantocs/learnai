class CreateApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :api_keys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token
      t.string :name
      t.boolean :active
      t.datetime :last_used_at

      t.timestamps
    end
  end
end
