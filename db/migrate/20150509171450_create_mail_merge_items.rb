class CreateMailMergeItems < ActiveRecord::Migration
  def change
    create_table :mail_merge_items do |t|
      t.string :filename
      t.string :url
      t.string :m_type
      t.references :mail_merge

      t.timestamps
    end
  end
end
