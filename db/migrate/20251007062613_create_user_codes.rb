class CreateUserCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :user_codes do |t|
      t.references :user, null: false, foreign_key: true
      t.text :qr_code_data
      t.string :url

      t.timestamps
    end
  end
end
