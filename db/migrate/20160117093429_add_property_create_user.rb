class AddPropertyCreateUser < ActiveRecord::Migration
  def change
  	add_column :properties, :property_create_user, :string

  	Property.all.each do |p|
  		if p.agent.name == "Landlord"
  			p.property_create_user = "landlord"
  		else
  			p.property_create_user = "admin"
  		end
  		p.save
  	end
  end
end
