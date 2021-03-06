class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.integer :user_id
      t.string :identifier
      t.boolean :has_it, default: false
      t.string :category

      t.timestamps null: false
    end
    add_index :interests, :user_id
    add_index :interests, :identifier
  end
end
