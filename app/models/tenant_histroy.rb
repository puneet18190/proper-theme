# == Schema Information
#
# Table name: tenant_histroys
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  tenancy_start_date :date
#  tenancy_end_date   :date
#  property_id        :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class TenantHistroy < ActiveRecord::Base
	belongs_to :property
end
