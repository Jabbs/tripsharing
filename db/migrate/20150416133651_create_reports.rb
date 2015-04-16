class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :daily_active_user_count

      t.timestamps
    end
  end
end
