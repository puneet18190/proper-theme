class CreateTenancyTerms < ActiveRecord::Migration
  def change
    create_table :tenancy_terms do |t|
      t.date :start_date
      t.string :tenancy_length
      t.string :agreed_rent
      t.string :agreed_bond
      t.string :advanced_payment
      t.boolean :shared
      t.boolean :garden
      t.boolean :parking
      t.boolean :other
      t.boolean :water
      t.boolean :council_tax
      t.boolean :gas
      t.boolean :electricity
      t.boolean :tv_licence
      t.boolean :telephone
      t.boolean :broadband
      t.boolean :other
      t.boolean :inventory
      t.boolean :guarantor_agreement
      t.boolean :epc
      t.boolean :rent_guide
      t.boolean :smoke_alarm
      t.boolean :pet
      t.integer :property_id

      t.timestamps
    end
  end
end
