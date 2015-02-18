class CreateContactAgents < ActiveRecord::Migration
  def change
    create_table :contact_agents do |t|
      t.string :name
      t.string :email
      t.string :message

      t.timestamps
    end
  end
end
