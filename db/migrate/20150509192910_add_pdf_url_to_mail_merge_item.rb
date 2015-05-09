class AddPdfUrlToMailMergeItem < ActiveRecord::Migration
  def change
    add_column :mail_merge_items, :pdf_url, :string
  end
end
