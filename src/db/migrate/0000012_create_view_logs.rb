class CreateViewLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :view_logs do |t|
      t.references :viewable, polymorphic: true, null: false
      t.references :account, foreign_key: true, null: true
      t.string :ip, limit: 45, null: true
      t.text :user_agent, null: true
      t.text :referer, null: true
      t.string :session_id, null: true
      t.string :device_type, null: true
      t.string :browser, null: true
      t.string :os, null: true
      t.boolean :is_bot, null: false, default: false
      t.datetime :viewed_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end
  end
end
