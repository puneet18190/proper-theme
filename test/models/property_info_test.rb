# == Schema Information
#
# Table name: property_infos
#
#  id                 :integer          not null, primary key
#  battery            :integer
#  battery_operated   :string(255)
#  mains              :integer
#  mains_operated     :string(255)
#  carbon             :integer
#  carbon_monoxide    :string(255)
#  elec_meter_loc     :string(255)
#  elec_last_supplier :string(255)
#  gas_meter_loc      :string(255)
#  gas_last_supplier  :string(255)
#  gas_valve          :string(255)
#  water_meter_loc    :string(255)
#  water_stopcock_loc :string(255)
#  bin_coll_day       :string(255)
#  alarm_loc          :string(255)
#  alarm_code         :string(255)
#  property_id        :integer
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class PropertyInfoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
