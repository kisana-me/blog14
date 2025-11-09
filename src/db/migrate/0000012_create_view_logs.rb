class CreateViewLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :view_logs do |t|
      t.references :viewable, polymorphic: true, null: false
      t.references :account, foreign_key: true, null: true
      t.string :ip, limit: 45, null: false
      t.text :user_agent, null: false, default: ""
      t.text :referer, null: false, default: ""
      t.string :session_id, null: false, default: ""
      t.string :device_type, null: false, default: ""
      t.string :browser, null: false, default: ""
      t.string :os, null: false, default: ""
      t.boolean :is_bot, null: false, default: false
      t.datetime :viewed_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end
  end
end
