# == Schema Information
#
# Table name: tenant_properties
#
#  id          :integer          not null, primary key
#  property_id :integer
#  tenant_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class TenantProperty < ActiveRecord::Base
end
