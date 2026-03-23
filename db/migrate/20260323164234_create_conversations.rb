class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.datetime :deleted_at
      t.integer :deleted_by

      t.timestamps
    end
  end
end
