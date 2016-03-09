class AddCallActionToYealinkPhone < ActiveRecord::Migration
  def change
    add_column :yealink_phones, :call_action, :string
  end
end
