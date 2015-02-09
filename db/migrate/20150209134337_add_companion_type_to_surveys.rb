class AddCompanionTypeToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :companion_type, :string
  end
end
