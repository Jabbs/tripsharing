class CreateImageAttachments < ActiveRecord::Migration
  def change
    create_table :image_attachments do |t|
      t.string :image_attachable_type
      t.integer :image_attachable_id
      t.string :image
      
      t.timestamps
    end
    add_index :image_attachments, :image_attachable_type
    add_index :image_attachments, :image_attachable_id
  end
end
