# == Schema Information
#
# Table name: tenancy_terms
#
#  id                  :integer          not null, primary key
#  start_date          :date
#  tenancy_length      :string(255)
#  agreed_rent         :string(255)
#  agreed_bond         :string(255)
#  advanced_payment    :string(255)
#  shared              :boolean
#  garden              :boolean
#  parking             :boolean
#  other               :boolean
#  water               :boolean
#  council_tax         :boolean
#  gas                 :boolean
#  electricity         :boolean
#  tv_licence          :boolean
#  telephone           :boolean
#  broadband           :boolean
#  inventory           :boolean
#  guarantor_agreement :boolean
#  epc                 :boolean
#  rent_guide          :boolean
#  smoke_alarm         :boolean
#  pet                 :boolean
#  property_id         :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class TenancyTerm < ActiveRecord::Base
	belongs_to :property
end
