class AddAgentIdToContactAgents < ActiveRecord::Migration
  def change
    add_column :contact_agents, :agent_id, :integer
  end
end
