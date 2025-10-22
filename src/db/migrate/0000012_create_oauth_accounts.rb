class CreateOauthAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :oauth_accounts do |t|
      t.string :aid, null: false, limit: 14
      t.references :account, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :code, null: true
      t.string :access_token, null: true
      t.string :refresh_token, null: true
      t.datetime :access_token_expires_at, null: true
      t.datetime :refresh_token_expires_at, null: true
      t.integer :status, limit: 1, null: false, default: 0

      t.timestamps
    end
    add_index :oauth_accounts, :aid, unique: true
    add_index :oauth_accounts, %i[provider uid], unique: true
  end
end
