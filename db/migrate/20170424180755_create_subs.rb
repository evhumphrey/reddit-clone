class CreateSubs < ActiveRecord::Migration
  def change
    create_table :subs do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end

    add_index :subs, :user_id
    add_index :subs, :title, unique: true
  end
end
