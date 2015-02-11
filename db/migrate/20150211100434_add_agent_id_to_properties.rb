class AddAgentIdToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :agent_id, :integer
  end
end
