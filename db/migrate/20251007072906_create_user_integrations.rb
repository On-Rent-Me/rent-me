class CreateUserIntegrations < ActiveRecord::Migration[8.0]
  def change
    create_table :user_integrations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :integration_type, null: false
      t.string :external_id
      t.text :access_token
      t.text :refresh_token
      t.datetime :expires_at
      t.json :metadata, default: {}
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :user_integrations, [:user_id, :integration_type], unique: true
    add_index :user_integrations, :external_id
  end
end
