class AddOrganizerTypeToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :organizer_type, :string
  end
end
