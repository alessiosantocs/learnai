class CreateApplicationConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :application_connections do |t|
      t.references :user, null: false, foreign_key: true
      t.references :integration, null: false, foreign_key: true
      t.jsonb :settings
      t.jsonb :metadata
      t.string :name
      t.boolean :active

      t.timestamps
    end
  end
end
