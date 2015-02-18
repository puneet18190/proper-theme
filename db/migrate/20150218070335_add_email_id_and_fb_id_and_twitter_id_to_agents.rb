class AddEmailIdAndFbIdAndTwitterIdToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :email_id, :string
    add_column :agents, :fb_id, :string
    add_column :agents, :twitter_id, :string
  end
end
