class RenameCalledIdFromYealinkPhone < ActiveRecord::Migration
  def change
  	rename_column :yealink_phones, :caller_id, :callerid
  	rename_column :yealink_phones, :call_action, :callaction
  end
end
