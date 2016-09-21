class CreateGuarantors < ActiveRecord::Migration
  def change
    create_table :guarantors do |t|
      t.string :firstname
      t.string :lastname
      t.string :previous_name
      t.string :dob
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :postcode
      t.string :home_tel
      t.string :mobile_tel
      t.string :email
      t.string :emp_status
      t.string :emp_from
      t.string :job_title
      t.string :annual_inc
      t.string :ref_name
      t.string :ref_job
      t.string :ref_company
      t.string :ref_address
      t.string :ref_tel
      t.string :ref_email
      t.string :ref_rel
      t.string :outcome
      t.text :add_info
      t.integer :property_id

      t.timestamps
    end
  end
end
