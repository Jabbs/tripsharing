class AddCohortToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cohort_blob, :string, default: ""
  end
end
