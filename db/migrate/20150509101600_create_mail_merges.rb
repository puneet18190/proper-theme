class CreateMailMerges < ActiveRecord::Migration
  def change
    create_table :mail_merges do |t|
      t.string :filename
      t.string :url
      t.string :m_type

      t.timestamps
    end
  end
end
