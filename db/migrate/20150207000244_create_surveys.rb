class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :destination, limit: 255
      t.integer :companion_count
      t.integer :user_id
      t.string :month, limit: 255
      t.string :hometown, limit: 255

      t.timestamps
    end
    add_index :surveys, :user_id
  end
end
