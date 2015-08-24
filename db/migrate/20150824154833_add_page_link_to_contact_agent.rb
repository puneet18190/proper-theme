class AddPageLinkToContactAgent < ActiveRecord::Migration
  def change
    add_column :contact_agents, :page_link, :string
  end
end
