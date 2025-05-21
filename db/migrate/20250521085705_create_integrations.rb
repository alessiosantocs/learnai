class CreateIntegrations < ActiveRecord::Migration[7.0]
  def change
    create_table :integrations do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :logo
      t.boolean :active

      t.timestamps
    end
  end
end
